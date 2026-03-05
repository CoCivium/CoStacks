Set-StrictMode -Version Latest
$ErrorActionPreference="SilentlyContinue"
$ProgressPreference="SilentlyContinue"

$repoTray = Join-Path $PSScriptRoot "CoGuardianTray.ps1"
$repoHelper = Join-Path $PSScriptRoot "Get-CoGuardianStatus.ps1"

$cacheDir = Join-Path $env:LOCALAPPDATA "CoCivium\CoGuardian\cache"
New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null

$localTray = Join-Path $cacheDir "CoGuardianTray.ps1"
$localHelper = Join-Path $cacheDir "Get-CoGuardianStatus.ps1"

# Best-effort refresh from repo path (may be UNC); fail open to existing local copies.
try { Copy-Item -LiteralPath $repoTray -Destination $localTray -Force } catch {}
try { Copy-Item -LiteralPath $repoHelper -Destination $localHelper -Force } catch {}

# Launch local tray hidden (STA). If local missing, fall back to repo tray.
$trayToRun = (Test-Path -LiteralPath $localTray) ? $localTray : $repoTray
Start-Process pwsh -WindowStyle Hidden -ArgumentList @("-NoProfile","-Sta","-ExecutionPolicy","Bypass","-File",$trayToRun) | Out-Null
