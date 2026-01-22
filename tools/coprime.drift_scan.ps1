param(
  [Parameter(Mandatory=$true)][string]$Manifest,
  [Parameter(Mandatory=$false)][string]$Root = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest

if(!(Test-Path -LiteralPath $Manifest)){ throw "MissingManifest: $Manifest" }
if(!(Test-Path -LiteralPath $Root)){ throw "MissingRoot: $Root" }

$m = (Get-Content -LiteralPath $Manifest -Raw -Encoding UTF8) | ConvertFrom-Json
$rootFull = (Resolve-Path -LiteralPath $Root).Path

$want = @{}
foreach($e in @($m.files)){ $want[$e.path] = ([string]$e.sha256).ToLowerInvariant() }

$have = Get-ChildItem -LiteralPath $rootFull -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  ForEach-Object {
    $rel = $_.FullName.Substring($rootFull.Length).TrimStart('\','/')
    $rel = ($rel -replace '\\','/')
    [pscustomobject]@{
      path   = $rel
      sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLowerInvariant()
    }
  }

$missing = @()
$changed = @()
foreach($k in $want.Keys){
  $h = ($have | Where-Object { $_.path -eq $k } | Select-Object -First 1).sha256
  if(-not $h){ $missing += $k; continue }
  if($h -ne $want[$k]){ $changed += $k }
}

$extra = @($have | Where-Object { -not $want.ContainsKey($_.path) } | Select-Object -ExpandProperty path)

if($missing.Count -eq 0 -and $changed.Count -eq 0 -and $extra.Count -eq 0){
  Write-Host "DRIFT NONE"
  exit 0
}

Write-Host "DRIFT DETECTED"
if($missing.Count){ Write-Host "MISSING:"; $missing | ForEach-Object { "  $_" } }
if($changed.Count){ Write-Host "CHANGED:"; $changed | ForEach-Object { "  $_" } }
if($extra.Count){ Write-Host "EXTRA:";   $extra   | ForEach-Object { "  $_" } }

exit 2
