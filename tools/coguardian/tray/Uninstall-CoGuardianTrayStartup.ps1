# Reversible (no admin): removes the per-user Startup shortcut for CoGuardianTray.
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

$startupDir = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
$lnkPath = Join-Path $startupDir 'CoStacks-CoGuardian-Tray.lnk'

if(Test-Path -LiteralPath $lnkPath){
  Remove-Item -LiteralPath $lnkPath -Force
  Write-Host "OK Removed Startup shortcut:"
  Write-Host "  $lnkPath"
} else {
  Write-Host "WARN Startup shortcut not found (nothing to remove):"
  Write-Host "  $lnkPath"
}
