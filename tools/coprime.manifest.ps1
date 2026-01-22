# coprime.manifest.ps1
# Create MANIFEST.json for a folder: list files + sha256.
# Usage: ./coprime.manifest.ps1 -InDir .\Package -OutFile .\MANIFEST.json
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$InDir,
  [Parameter(Mandatory=$true)][string]$OutFile
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (!(Test-Path -LiteralPath $InDir)) { throw "Missing InDir: $InDir" }
$root = (Resolve-Path -LiteralPath $InDir).Path

$files = Get-ChildItem -LiteralPath $root -Recurse -File | Sort-Object FullName

$items = foreach ($f in $files) {
  $rel = $f.FullName.Substring($root.Length).TrimStart('\','/')
  [pscustomobject]@{
    path = $rel
    bytes = $f.Length
    sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $f.FullName).Hash.ToLowerInvariant()
  }
}

$manifest = [pscustomobject]@{
  generated_utc = (Get-Date).ToUniversalTime().ToString("o")
  root = $root
  file_count = $items.Count
  files = $items
}

$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutFile -Encoding UTF8
Write-Host "MANIFEST written: $OutFile (files=$($items.Count))"
