$p = Join-Path $env:LOCALAPPDATA 'CoCivium\CoGuardian\tray_telemetry.log'
if(Test-Path -LiteralPath $p){
  Clear-Content -LiteralPath $p
  Write-Host "Cleared: $p"
} else {
  Write-Host "No telemetry log yet: $p"
}
