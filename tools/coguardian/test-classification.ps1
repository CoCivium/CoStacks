# Deterministic, offline classification smoke test for CoGuardian shadow scanner.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$out = Join-Path ([System.IO.Path]::GetTempPath()) ('coguardian-test-' + [guid]::NewGuid().ToString('N') + '.md')
function Invoke-WebRequest {
  param([string]$Uri, [int]$TimeoutSec)
  if ($Uri -match '/Sub1__LATEST.md$') {
    return [pscustomobject]@{ Content='UTC=20261123T120000Z STATE=ACTIVE' }
  }
  if ($Uri -match '/Sub2__LATEST.md$') {
    return [pscustomobject]@{ Content='STATE=ACTIVE' }
  }
  if ($Uri -match '/Sub3__LATEST.md$') {
    $ex = [System.Exception]::new('Not Found')
    $response = [pscustomobject]@{ StatusCode = 404 }
    $ex | Add-Member -NotePropertyName Response -NotePropertyValue $response
    throw $ex
  }
  if ($Uri -match '/Sub4__LATEST.md$') {
    throw [System.Exception]::new('Simulated timeout')
  }
  return [pscustomobject]@{ Content='fixture' }
}
try {
  & (Join-Path $root 'tools/coguardian/scan.ps1') -CoBusMirrorSha ('a' * 40) -MaxSubs 4 -OutPath $out
  $report = Get-Content -LiteralPath $out -Raw
  $expected = @(
    '| Sub1 | FIELDS_PRESENT_FRESHNESS_UNKNOWN |',
    '| Sub2 | NEEDS_UTC |',
    '| Sub3 | NOT_FOUND |',
    '| Sub4 | FETCH_ERROR |',
    '- FIELDS_PRESENT_FRESHNESS_UNKNOWN=1',
    '- NEEDS_FIELDS=1',
    '- NOT_FOUND=1',
    '- FETCH_ERROR=1',
    '- LIVENESS=UNPROVEN'
  )
  foreach ($needle in $expected) {
    if (-not $report.Contains($needle)) { throw "Missing expected scanner output: $needle" }
  }
  Write-Host 'PASS: four offline scanner classifications and no liveness inference'
}
finally {
  Remove-Item -LiteralPath $out -ErrorAction SilentlyContinue
}
