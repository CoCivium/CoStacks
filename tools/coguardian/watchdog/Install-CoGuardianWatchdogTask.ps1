Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

$taskName = "CoCivium.CoGuardian.Watchdog"
$script = Join-Path $PSScriptRoot "Invoke-CoGuardianWatchdog.ps1"
if(-not (Test-Path -LiteralPath $script)){ throw "Missing watchdog script: $script" }

# Run pwsh if available; else Windows PowerShell
$pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue)?.Source
if($pwsh){
  $exe = $pwsh
  $args = "-NoProfile -ExecutionPolicy Bypass -File `"$script`""
} else {
  $exe = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
  $args = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script`""
}

# Trigger: start ~1 minute from now, repeat every 1 minute for 1 day; also re-triggers daily
$start = (Get-Date).AddMinutes(1)

$action   = New-ScheduledTaskAction -Execute $exe -Argument $args
$trigger  = New-ScheduledTaskTrigger -Daily -At $start
$trigger.RepetitionInterval = New-TimeSpan -Minutes 1
$trigger.RepetitionDuration = New-TimeSpan -Days 1

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew

try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue } catch {}

# IMPORTANT: if this throws, caller should fail (no “Installed” lies)
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description "CoGuardian watchdog: restarts tray/bootstrap if heartbeat stale or tray missing." | Out-Null

Write-Host "Installed scheduled task: $taskName"
