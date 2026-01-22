# coprime.verify_manifest.ps1
# Verify MANIFEST.json file hashes against a folder.
# Usage: ./coprime.verify_manifest.ps1 -Manifest .\MANIFEST.json -Root .\
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Manifest,
  [Parameter(Mandatory=$true)][string]$Root
)

$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest

if (!(Test-Path -LiteralPath $Manifest)) { throw "Missing manifest: $Manifest" }
if (!(Test-Path -LiteralPath $Root)) { throw "Missing root: $Root" }

$rootPath = (Resolve-Path -LiteralPath $Root).Path
$man = Get-Content -LiteralPath $Manifest -Encoding UTF8 | ConvertFrom-Json

$fail = 0
foreach ($f in $man.files) {
  $rel = [string]$f.path
  $expected = ([string]$f.sha256).ToLowerInvariant()
  $full = Join-Path $rootPath $rel
  if (!(Test-Path -LiteralPath $full)) {
    Write-Host "MISSING: $rel"
    $fail++
    continue
  }
  $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $full).Hash.ToLowerInvariant()
  if ($actual -ne $expected) {
    Write-Host "MISMATCH: $rel expected=$expected actual=$actual"
    $fail++
  }
}

if ($fail -gt 0) {
  Write-Host "VERIFY FAIL: $fail problems"
  exit 2
} else {
  Write-Host "VERIFY PASS"
  exit 0
}
