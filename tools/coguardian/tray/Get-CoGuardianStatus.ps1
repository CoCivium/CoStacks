param(
  [switch]$Raw
)
Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$path = Join-Path $env:LOCALAPPDATA "CoCivium\CoGuardian\status.json"
if(-not (Test-Path -LiteralPath $path)){
  Write-Host "NO_STATUS_FILE: $path"
  exit 2
}

$j = Get-Content -LiteralPath $path -Raw -Encoding UTF8
if($Raw){ $j; exit 0 }

try {
  $o = $j | ConvertFrom-Json
  "{0} STATE={1} HB={2} ERR={3} PID={4}" -f `
    (Get-Date).ToUniversalTime().ToString("HH:mm:ssZ"), `
    $o.State, $o.LastHeartbeatUTC, $o.LastErrorUTC, $o.PID
} catch {
  Write-Host "BAD_JSON: $path"
  $j
  exit 3
}
