# Reversible: installs a per-user Scheduled Task that launches CoGuardianTray on logon.
# Stability-first: no registry hacks, no policies, no admin requirement (best-effort).
param(
  [string]$RepoRoot = "$PSScriptRoot\..\..\.."
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Fail([string]$m){ throw "FAIL: $m" }

try { Import-Module ScheduledTasks -ErrorAction Stop } catch { }

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$tray = Join-Path $RepoRoot 'tools\coguardian\tray\CoGuardianTray.ps1'
if(-not (Test-Path -LiteralPath $tray)){ Fail "Missing tray: $tray" }

$taskName = "CoStacks-CoGuardian-Tray"
$pwsh = (Get-Command pwsh -ErrorAction Stop).Source

# Build a safe argument string. Quote items that contain whitespace.
$argsList = @('-NoProfile','-ExecutionPolicy','Bypass','-File', $tray)
$argStr = ($argsList | ForEach-Object {
  $s = [string]$_
  if($s -match '\s'){ '"' + $s + '"' } else { $s }
}) -join ' '

$action   = New-ScheduledTaskAction -Execute $pwsh -Argument $argStr -WorkingDirectory $RepoRoot
$trigger  = New-ScheduledTaskTrigger -AtLogOn

# Use explicit DOMAIN\USER if available; fallback to USERNAME.
$userId = if($env:USERDOMAIN){ "$($env:USERDOMAIN)\$($env:USERNAME)" } else { $env:USERNAME }
$principal = New-ScheduledTaskPrincipal -UserId $userId -LogonType Interactive -RunLevel Limited

$settings = New-ScheduledTaskSettingsSet `
  -AllowStartIfOnBatteries `
  -DontStopIfGoingOnBatteries `
  -MultipleInstances IgnoreNew `
  -ExecutionTimeLimit ([TimeSpan]::Zero) `
  -RestartCount 3 `
  -RestartInterval (New-TimeSpan -Minutes 1)

# Replace if exists
try { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null } catch { }

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null

Write-Host "OK Installed Scheduled Task: $taskName"
Write-Host "Test now: schtasks /Run /TN `"$taskName`""

