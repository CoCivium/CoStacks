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

# Every 1 minute, indefinitely
$action  = New-ScheduledTaskAction -Execute $exe -Argument $args
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration ([TimeSpan]::MaxValue)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew

# Per-user task
try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue } catch {}
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description "CoGuardian watchdog: restarts tray/bootstrap if heartbeat stale or tray missing." | Out-Null

Write-Host "Installed scheduled task: $taskName"
