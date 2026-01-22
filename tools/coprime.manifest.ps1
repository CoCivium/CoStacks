param(
  [Parameter(Mandatory=$false)][string]$Root = (Split-Path $PSScriptRoot -Parent),
  [Parameter(Mandatory=$false)][string]$Out  = (Join-Path (Split-Path $PSScriptRoot -Parent) ("MANIFEST_{0}.json" -f (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')))
)

$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest

$rootFull = (Resolve-Path -LiteralPath $Root).Path
$outFull  = (Resolve-Path -LiteralPath (Split-Path -Parent $Out) -ErrorAction SilentlyContinue)?.Path
if(-not $outFull){ New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Out) | Out-Null }

# enumerate files (exclude .git and the output manifest itself if under Root)
$files = Get-ChildItem -LiteralPath $rootFull -Recurse -File -Force |
  Where-Object {
    $_.FullName -notmatch '\\\.git\\' -and
    $_.FullName -ne (Resolve-Path -LiteralPath $Out -ErrorAction SilentlyContinue).Path
  } |
  Sort-Object FullName

$entries = foreach($f in $files){
  $rel = $f.FullName.Substring($rootFull.Length).TrimStart('\','/')
  [pscustomobject]@{
    path   = ($rel -replace '\\','/')
    bytes  = [int64]$f.Length
    sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $f.FullName).Hash.ToLowerInvariant()
  }
}

$manifest = [pscustomobject]@{
  manifest_version = "v1"
  generated_utc    = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
  root             = ($rootFull -replace '\\','/')
  file_count       = @($entries).Count
  files            = @($entries)
}

($manifest | ConvertTo-Json -Depth 10) | Set-Content -LiteralPath $Out -Encoding UTF8
Write-Host ("MANIFEST OK: {0}" -f $Out)
