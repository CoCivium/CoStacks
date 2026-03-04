# Reversible: installs a per-user Scheduled Task that launches CoGuardianTray on logon.
# Stability-first: no registry hacks, no policies, no admin requirement (best-effort).
param(
  [string]$RepoRoot = "$PSScriptRoot\..\..\.."
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Fail([string]$m){ throw "FAIL: $m" }

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$tray = Join-Path $RepoRoot 'tools\coguardian\tray\CoGuardianTray.ps1'
if(-not (Test-Path -LiteralPath $tray)){ Fail "Missing tray: $tray" }

$taskName = "CoStacks-CoGuardian-Tray"
$pwsh = (Get-Command pwsh -ErrorAction Stop).Source

# Launch detached-ish: scheduled task runs independently of any console window you close.
$argsList = @('-NoProfile','-ExecutionPolicy','Bypass','-File',$tray); $args = ($argsList | ForEach-Object { if(# Reversible: installs a per-user Scheduled Task that launches CoGuardianTray on logon.
# Stability-first: no registry hacks, no policies, no admin requirement (best-effort).
param(
  [string]$RepoRoot = "$PSScriptRoot\..\..\.."
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Fail([string]$m){ throw "FAIL: $m" }

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$tray = Join-Path $RepoRoot 'tools\coguardian\tray\CoGuardianTray.ps1'
if(-not (Test-Path -LiteralPath $tray)){ Fail "Missing tray: $tray" }

$taskName = "CoStacks-CoGuardian-Tray"
$pwsh = (Get-Command pwsh -ErrorAction Stop).Source

# Launch detached-ish: scheduled task runs independently of any console window you close.
$args = "-NoProfile -ExecutionPolicy Bypass -File "$tray""
$action = New-ScheduledTaskAction -Execute $pwsh -Argument $args -WorkingDirectory $RepoRoot
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel LeastPrivilege
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 0) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

# Replace if exists
try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null } catch { }

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null
Write-Host "OK Installed Scheduled Task: $taskName"
Write-Host "Test now: schtasks /Run /TN "$taskName""
 -match '\s' ){ '"'+# Reversible: installs a per-user Scheduled Task that launches CoGuardianTray on logon.
# Stability-first: no registry hacks, no policies, no admin requirement (best-effort).
param(
  [string]$RepoRoot = "$PSScriptRoot\..\..\.."
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Fail([string]$m){ throw "FAIL: $m" }

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$tray = Join-Path $RepoRoot 'tools\coguardian\tray\CoGuardianTray.ps1'
if(-not (Test-Path -LiteralPath $tray)){ Fail "Missing tray: $tray" }

$taskName = "CoStacks-CoGuardian-Tray"
$pwsh = (Get-Command pwsh -ErrorAction Stop).Source

# Launch detached-ish: scheduled task runs independently of any console window you close.
$args = "-NoProfile -ExecutionPolicy Bypass -File "$tray""
$action = New-ScheduledTaskAction -Execute $pwsh -Argument $args -WorkingDirectory $RepoRoot
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel LeastPrivilege
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 0) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

# Replace if exists
try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null } catch { }

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null
Write-Host "OK Installed Scheduled Task: $taskName"
Write-Host "Test now: schtasks /Run /TN "$taskName""
+'"' } else { # Reversible: installs a per-user Scheduled Task that launches CoGuardianTray on logon.
# Stability-first: no registry hacks, no policies, no admin requirement (best-effort).
param(
  [string]$RepoRoot = "$PSScriptRoot\..\..\.."
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Fail([string]$m){ throw "FAIL: $m" }

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$tray = Join-Path $RepoRoot 'tools\coguardian\tray\CoGuardianTray.ps1'
if(-not (Test-Path -LiteralPath $tray)){ Fail "Missing tray: $tray" }

$taskName = "CoStacks-CoGuardian-Tray"
$pwsh = (Get-Command pwsh -ErrorAction Stop).Source

# Launch detached-ish: scheduled task runs independently of any console window you close.
$args = "-NoProfile -ExecutionPolicy Bypass -File "$tray""
$action = New-ScheduledTaskAction -Execute $pwsh -Argument $args -WorkingDirectory $RepoRoot
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel LeastPrivilege
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 0) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

# Replace if exists
try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null } catch { }

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null
Write-Host "OK Installed Scheduled Task: $taskName"
Write-Host "Test now: schtasks /Run /TN "$taskName""
 } }) -join ' '
$action = New-ScheduledTaskAction -Execute $pwsh -Argument $args -WorkingDirectory $RepoRoot
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel LeastPrivilege
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 0) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

# Replace if exists
try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null } catch { }

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null
Write-Host "OK Installed Scheduled Task: $taskName"
Write-Host "Test now: schtasks /Run /TN "$taskName""

