$p = Join-Path $env:LOCALAPPDATA 'CoCivium\CoGuardian\tray_telemetry.log'
if(Test-Path -LiteralPath $p){
  Get-Content -LiteralPath $p -Tail 600
} else {
  Write-Host "No telemetry log yet: $p"
}
