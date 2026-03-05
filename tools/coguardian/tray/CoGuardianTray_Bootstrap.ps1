param()

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function NowUtc(){ (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') }
function LogLine([string]$path,[string]$m){
  try { Add-Content -LiteralPath $path -Value ("[{0}] {1}" -f (NowUtc), $m) -Encoding UTF8 } catch {}
}

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$TrayPath = Join-Path $RepoRoot "tools\coguardian\tray\CoGuardianTray.ps1"

$BootLog = Join-Path $env:USERPROFILE ("Downloads\CoGuardianTray_bootstrap__{0}.log.txt" -f (NowUtc))
LogLine $BootLog ("BOOTSTRAP_START RepoRoot=" + $RepoRoot)
LogLine $BootLog ("TrayPath=" + $TrayPath)

if(-not (Test-Path -LiteralPath $TrayPath)){
  LogLine $BootLog ("FAIL Missing TrayPath=" + $TrayPath)
  throw "FAIL-CLOSED: Missing tray script at $TrayPath"
}

function GetTrayProcs(){
  Get-CimInstance Win32_Process |
    Where-Object { $_.Name -eq 'pwsh.exe' -and $_.CommandLine -match 'CoGuardianTray\.ps1' } |
    Select-Object ProcessId,CommandLine
}

function HardKill([int]$pid){
  try {
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
  } catch {}
  Start-Sleep -Milliseconds 150
  try {
    if(Get-Process -Id $pid -ErrorAction SilentlyContinue){
      & "$env:WINDIR\System32\taskkill.exe" /PID $pid /F /T | Out-Null
    }
  } catch {}
}

# HARD DEDUPE (pre-launch)
try {
  $procs = GetTrayProcs
  $cnt = ($procs | Measure-Object).Count
  LogLine $BootLog ("PRE_FOUND_TRAY_PROCS count=" + $cnt)
  foreach($p in $procs){
    LogLine $BootLog ("PRE_KILLING_PID=" + $p.ProcessId)
    HardKill ([int]$p.ProcessId)
  }
} catch {
  LogLine $BootLog ("PRE_PROC_SCAN_ERROR " + $_.Exception.Message)
}

Start-Sleep -Milliseconds 500

# ACTIVE LOG (precreate + rotate)
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

# Launch tray
try {
  $pwsh = (Get-Command pwsh -ErrorAction Stop).Source
  LogLine $BootLog ("PWSH=" + $pwsh)
  LogLine $BootLog "LAUNCH_TRAY"
  Start-Process -FilePath $pwsh -WindowStyle Hidden -ArgumentList @(
    '-NoProfile','-ExecutionPolicy','Bypass','-File',"$TrayPath",
    '-LogPath',"$Active"
  ) | Out-Null
  LogLine $BootLog "LAUNCH_TRAY_OK"
} catch {
  LogLine $BootLog ("LAUNCH_TRAY_ERROR " + $_.Exception.Message)
  throw
}

Start-Sleep -Milliseconds 600

# HARD DEDUPE (post-launch) -> keep newest
try {
  $procs2 = GetTrayProcs
  $cnt2 = ($procs2 | Measure-Object).Count
  LogLine $BootLog ("POST_FOUND_TRAY_PROCS count=" + $cnt2)
  if($cnt2 -gt 1){
    $keep = (Get-Process -Id ($procs2.ProcessId) | Sort-Object StartTime -Descending | Select-Object -First 1).Id
    LogLine $BootLog ("POST_KEEP_PID=" + $keep)
    foreach($p in $procs2){
      if([int]$p.ProcessId -ne [int]$keep){
        LogLine $BootLog ("POST_KILLING_PID=" + $p.ProcessId)
        HardKill ([int]$p.ProcessId)
      }
    }
  }
} catch {
  LogLine $BootLog ("POST_DEDUPE_ERROR " + $_.Exception.Message)
}

LogLine $BootLog ("BOOTSTRAP_DONE BootLog=" + $BootLog)