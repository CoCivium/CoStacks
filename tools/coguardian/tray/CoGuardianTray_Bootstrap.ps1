param()

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function NowUtc(){ (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') }
function LogLine([string]$path,[string]$m){
  try { Add-Content -LiteralPath $path -Value ("[{0}] {1}" -f (NowUtc), $m) -Encoding UTF8 } catch {}
}

# RepoRoot: ...\tools\coguardian\tray  ->  repo root
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$TrayPath = Join-Path $RepoRoot "tools\coguardian\tray\CoGuardianTray.ps1"

$BootLog = Join-Path $env:USERPROFILE ("Downloads\CoGuardianTray_bootstrap__{0}.log.txt" -f (NowUtc))
LogLine $BootLog ("BOOTSTRAP_START RepoRoot=" + $RepoRoot)
LogLine $BootLog ("TrayPath=" + $TrayPath)

if(-not (Test-Path -LiteralPath $TrayPath)){
  LogLine $BootLog ("FAIL Missing TrayPath=" + $TrayPath)
  throw "FAIL-CLOSED: Missing tray script at $TrayPath"
}

# HARD DEDUPE: kill any running tray instances (old or new)
try {
  $procs = Get-CimInstance Win32_Process |
    Where-Object { $_.Name -eq 'pwsh.exe' -and $_.CommandLine -match [regex]::Escape("$TrayPath") } |
    Select-Object ProcessId,CommandLine
  $cnt = ($procs | Measure-Object).Count
  LogLine $BootLog ("FOUND_TRAY_PROCS count=" + $cnt)
  foreach($p in $procs){
    try {
      LogLine $BootLog ("KILLING_PID=" + $p.ProcessId)
      Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue
    } catch {
      LogLine $BootLog ("KILL_ERROR pid=" + $p.ProcessId + " msg=" + $_.Exception.Message)
    }
  }
} catch {
  LogLine $BootLog ("PROC_SCAN_ERROR " + $_.Exception.Message)
}

Start-Sleep -Milliseconds 500

# Rotate ACTIVE log for unambiguous verification
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

LogLine $BootLog ("BOOTSTRAP_DONE BootLog=" + $BootLog)