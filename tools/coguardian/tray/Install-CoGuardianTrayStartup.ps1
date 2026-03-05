# Reversible (no admin): installs a per-user Startup shortcut that launches CoGuardianTray at logon.
param(
  [string]$RepoRoot = "$PSScriptRoot\..\..\.."
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

function Fail([string]$m){ throw "FAIL: $m" }

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$tray = (Resolve-Path -LiteralPath (Join-Path $RepoRoot 'tools\coguardian\tray\CoGuardianTray.ps1')).Path
if(-not (Test-Path -LiteralPath $tray)){ Fail "Missing tray: $tray" }

$pwsh = (Get-Command pwsh -ErrorAction Stop).Source

$startupDir = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
if(-not (Test-Path -LiteralPath $startupDir)){ Fail "Startup folder not found: $startupDir" }

$lnkPath = Join-Path $startupDir 'CoStacks-CoGuardian-Tray.lnk'

# Shortcut target = pwsh, args = run tray file
$args = @('-NoProfile','-Sta','-ExecutionPolicy','Bypass','-File', $tray)
# Build argument string with quoting where needed
$argStr = ($args | ForEach-Object {
  $s = [string]$_
  if($s -match '\s'){ '"' + $s + '"' } else { $s }
}) -join ' '

# Create .lnk
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut($lnkPath)
$sc.TargetPath = $pwsh
$sc.Arguments  = $argStr
$sc.WorkingDirectory = $RepoRoot
$sc.WindowStyle = 7   # Minimized
$sc.Description = 'CoStacks CoGuardian Tray (auto-start at logon)'
$sc.Save()

Write-Host "OK Installed Startup shortcut:"
Write-Host "  $lnkPath"
Write-Host "Test now by launching the shortcut (Explorer -> Startup folder) or run:"
Write-Host "  `"$pwsh`" $argStr"


