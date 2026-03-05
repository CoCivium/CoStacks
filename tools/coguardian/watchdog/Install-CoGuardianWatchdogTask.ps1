Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

$taskName = "CoCivium.CoGuardian.Watchdog"
$script = Join-Path $PSScriptRoot "Invoke-CoGuardianWatchdog.ps1"
if(-not (Test-Path -LiteralPath $script)){ throw "Missing watchdog script: $script" }

$pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue)?.Source
if($pwsh){
  $exe = $pwsh
  $args = "-NoProfile -ExecutionPolicy Bypass -File `"$script`""
} else {
  $exe = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
  $args = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script`""
}

# Start ~1 minute from now; repeat every 1 minute for 1 day (renewable).
$start = (Get-Date).AddMinutes(1)

$action  = New-ScheduledTaskAction -Execute $exe -Argument $args
$trigger = New-ScheduledTaskTrigger -Once -At $start -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration (New-TimeSpan -Days 1)

# Stability-first: prevent long-run weirdness
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 1)

try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue } catch {}

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description "CoGuardian watchdog: restarts tray/bootstrap if heartbeat stale or tray missing (throttled + quarantine)." | Out-Null
Write-Host "Installed scheduled task: $taskName"
