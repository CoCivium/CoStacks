param(
  [Parameter(Mandatory=$true)][string]$Manifest,
  [Parameter(Mandatory=$false)][string]$Root = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest

function Fail([string]$msg){ Write-Host $msg; exit 1 }

if(!(Test-Path -LiteralPath $Manifest)){ Fail "VERIFY FAIL: Missing manifest: $Manifest" }
if(!(Test-Path -LiteralPath $Root)){ Fail "VERIFY FAIL: Missing root: $Root" }

$m = (Get-Content -LiteralPath $Manifest -Raw -Encoding UTF8) | ConvertFrom-Json
$rootFull = (Resolve-Path -LiteralPath $Root).Path

$bad = @()
foreach($e in @($m.files)){
  $p = Join-Path $rootFull ($e.path -replace '/','\')
  if(!(Test-Path -LiteralPath $p)){
    $bad += "MISSING: $($e.path)"
    continue
  }
  $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLowerInvariant()
  if($h -ne ([string]$e.sha256).ToLowerInvariant()){
    $bad += "HASH_MISMATCH: $($e.path)"
  }
}

if($bad.Count -gt 0){
  $bad | ForEach-Object { Write-Host $_ }
  Fail "VERIFY FAIL"
}

Write-Host "VERIFY PASS"
