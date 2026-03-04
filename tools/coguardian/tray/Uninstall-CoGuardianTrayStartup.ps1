# Reversible: removes per-user Scheduled Task that launches CoGuardianTray on logon.
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$taskName = "CoStacks-CoGuardian-Tray"
try {
  Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop | Out-Null
  Write-Host "OK Removed Scheduled Task: $taskName"
} catch {
  Write-Host "WARN Could not remove task (may not exist): $taskName :: " + $_.Exception.Message
}
