<# CoGuardianTray_Bootstrap (canonical)
   - No prompts
   - Logs to Downloads
   - Launches resident tray process (CoGuardianTray.ps1)
#>
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function NowUtc(){ (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') }
$log = Join-Path $env:USERPROFILE ("Downloads\CoGuardianTray_bootstrap__" + (NowUtc) + ".log.txt")
function Log([string]$m){
  $line = ("[{0}] {1}" -f (NowUtc), $m)
  try { Add-Content -LiteralPath $log -Value $line -Encoding UTF8 } catch {}
}

try {
  Log ("BOOT START log=" + $log)
  $pwshExe = "C:\Program Files\WindowsApps\Microsoft.PowerShell_7.5.4.0_x64__8wekyb3d8bbwe\pwsh.exe"
  $trayScript = Join-Path $PSScriptRoot "CoGuardianTray.ps1"
  if(-not (Test-Path -LiteralPath $pwshExe)){ throw "Missing pwsh.exe at $pwshExe" }
  if(-not (Test-Path -LiteralPath $trayScript)){ throw "Missing tray script at $trayScript" }

  $debug = ($env:COGUARDIAN_TRAY_DEBUG -eq '1')
  $ws = if($debug){ 'Normal' } else { 'Hidden' }

  Log ("Launching tray: pwsh=" + $pwshExe)
  Log ("TrayScript=" + $trayScript)
  Log ("WindowStyle=" + $ws)

  Start-Process -FilePath $pwshExe -WindowStyle $ws -ArgumentList @(
    '-NoProfile','-ExecutionPolicy','Bypass','-File',$trayScript,
    '-LogPath', (Join-Path $env:USERPROFILE ("Downloads\CoGuardianTray__ACTIVE.log.txt"))
  ) | Out-Null

  Log "BOOT DONE"
} catch {
  Log ("BOOT ERROR: " + $_)
  try { $_ | Out-String | Add-Content -LiteralPath $log -Encoding UTF8 } catch {}
  throw
}