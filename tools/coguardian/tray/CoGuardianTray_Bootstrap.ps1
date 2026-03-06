param()

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function NowUtc(){ (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') }
function LogLine([string]$path,[string]$m){
  try { Add-Content -LiteralPath $path -Value ("[{0}] {1}" -f (NowUtc), $m) -Encoding UTF8 } catch {}
}

# Resolve repo root to a clean filesystem path (no provider prefix, no .. segments)
$RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).ProviderPath

# Build TrayPath, then resolve to eliminate any .. segments
$TrayCandidate = Join-Path $RepoRoot "tools\coguardian\tray\CoGuardianTray.ps1"
$TrayPath = (Resolve-Path -LiteralPath $TrayCandidate).ProviderPath

$BootLog = Join-Path $env:USERPROFILE ("Downloads\CoGuardianTray_bootstrap__{0}.log.txt" -f (NowUtc))
LogLine $BootLog ("BOOTSTRAP_START RepoRoot=" + $RepoRoot)
LogLine $BootLog ("TrayPath=" + $TrayPath)

if(-not (Test-Path -LiteralPath $TrayPath)){
  LogLine $BootLog ("FAIL Missing TrayPath=" + $TrayPath)
  throw "FAIL-CLOSED: Missing tray script at $TrayPath"
}

function GetTrayProcs(){
  $esc = [regex]::Escape($TrayPath)
  Get-CimInstance Win32_Process |
    Where-Object { $_.Name -eq 'pwsh.exe' -and $_.CommandLine -match $esc } |
    Select-Object ProcessId,CommandLine
}

function HardKill([int]$procId){
  try { Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue } catch {}
  Start-Sleep -Milliseconds 150
  try {
    if(Get-Process -Id $procId -ErrorAction SilentlyContinue){
      & "$env:WINDIR\System32\taskkill.exe" /PID $procId /F /T | Out-Null
    }
  } catch {}
}

# HARD DEDUPE (pre-launch)
try {
  $procs = GetTrayProcs
  $cnt = ($procs | Measure-Object).Count
  LogLine $BootLog ("PRE_FOUND_TRAY_PROCS count=" + $cnt)
  foreach($proc in $procs){
    $procId = [int]$proc.ProcessId
    LogLine $BootLog ("PRE_KILLING_PID=" + $procId)
    HardKill $procId
  }
} catch {
  LogLine $BootLog ("PRE_PROC_SCAN_ERROR " + $_.Exception.Message)
}

Start-Sleep -Milliseconds 500

# ACTIVE LOG (rotate + precreate)
$Active = Join-Path $env:USERPROFILE "Downloads\CoGuardianTray__ACTIVE.log.txt"
try {
  if(Test-Path -LiteralPath $Active){
    $bak = Join-Path $env:USERPROFILE ("Downloads\CoGuardianTray__ACTIVE__{0}.bak.txt" -f (NowUtc))
    Move-Item -LiteralPath $Active -Destination $bak -Force
    LogLine $BootLog ("ACTIVE_LOG_ROTATED to " + $bak)
  }
} catch {
  LogLine $BootLog ("LOG_ROTATE_ERROR " + $_.Exception.Message)
}
try {
  New-Item -ItemType File -Force -Path $Active | Out-Null
  LogLine $BootLog ("ACTIVE_LOG_PRECREATED " + $Active)
} catch {
  LogLine $BootLog ("ACTIVE_LOG_PRECREATE_ERROR " + $_.Exception.Message)
}

# Launch tray (force -STA)
try {
  $pwshExe = (Get-Command pwsh -ErrorAction Stop).Source
  LogLine $BootLog ("PWSH=" + $pwshExe)
  LogLine $BootLog ("LAUNCH_TRAY")
  Start-Process -FilePath $pwshExe -WindowStyle Hidden -ArgumentList @(
    '-STA',
    '-NoProfile','-ExecutionPolicy','Bypass','-File',"$TrayPath",
    '-LogPath',"$Active"
  ) | Out-Null
  LogLine $BootLog ("LAUNCH_TRAY_OK")
} catch {
  LogLine $BootLog ("LAUNCH_TRAY_ERROR " + $_.Exception.Message)
  throw
}

Start-Sleep -Milliseconds 700

# HARD DEDUPE (post-launch) -> keep newest
try {
  $procs2 = GetTrayProcs
  $cnt2 = ($procs2 | Measure-Object).Count
  LogLine $BootLog ("POST_FOUND_TRAY_PROCS count=" + $cnt2)
  if($cnt2 -gt 1){
    $keepId = (Get-Process -Id ($procs2.ProcessId) | Sort-Object StartTime -Descending | Select-Object -First 1).Id
    LogLine $BootLog ("POST_KEEP_PID=" + $keepId)
    foreach($proc2 in $procs2){
      $procId2 = [int]$proc2.ProcessId
      if($procId2 -ne [int]$keepId){
        LogLine $BootLog ("POST_KILLING_PID=" + $procId2)
        HardKill $procId2
      }
    }
  }
} catch {
  LogLine $BootLog ("POST_DEDUPE_ERROR " + $_.Exception.Message)
}

LogLine $BootLog ("BOOTSTRAP_DONE BootLog=" + $BootLog)