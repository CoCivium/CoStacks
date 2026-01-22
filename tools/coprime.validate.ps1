# coprime.validate.ps1
# Seed-minimal validator for CanonicalPaths.yml + PointerRegistry.jsonl invariants.
# Usage: ./coprime.validate.ps1 -PathsFile .\CanonicalPaths.yml
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$PathsFile
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Read-FlatYaml([string]$Path) {
  if (!(Test-Path -LiteralPath $Path)) { throw "Missing PathsFile: $Path" }
  $map = [ordered]@{}
  $lines = Get-Content -LiteralPath $Path -Encoding UTF8
  foreach ($raw in $lines) {
    $line = $raw.Trim()
    if ($line -eq "" -or $line.StartsWith("#")) { continue }
    if ($line -notmatch '^(?<k>[A-Za-z0-9_]+)\s*:\s*(?<v>.+)\s*$') { throw "Unsupported YAML line (must be flat key: value): $raw" }
    $k = $Matches['k']
    $v = $Matches['v'].Trim()
    if (($v.StartsWith('"') -and $v.EndsWith('"')) -or ($v.StartsWith("'") -and $v.EndsWith("'"))) {
      $v = $v.Substring(1, $v.Length-2)
    }
    $map[$k] = $v
  }
  return $map
}

function Require-Key($map, [string]$key) {
  if (-not $map.Contains($key)) { throw "CanonicalPaths missing required key: $key" }
  if ([string]::IsNullOrWhiteSpace($map[$key])) { throw "CanonicalPaths key is empty: $key" }
}

function Read-JsonLines([string]$Path) {
  if (!(Test-Path -LiteralPath $Path)) { throw "Missing PointerRegistry: $Path" }
  $objs = @()
  $i = 0
  foreach ($line in (Get-Content -LiteralPath $Path -Encoding UTF8)) {
    $i++
    $t = $line.Trim()
    if ($t -eq "" -or $t.StartsWith("#")) { continue }
    try {
      $obj = $t | ConvertFrom-Json -ErrorAction Stop
      $objs += $obj
    } catch {
      throw "PointerRegistry JSON parse error at line ${i}: $($_.Exception.Message)"
    }
  }
  return $objs
}

# --- Validate CanonicalPaths
$paths = Read-FlatYaml -Path $PathsFile
$required = @('CanonicalPathsVersion','MasterPlanLatest','PointerRegistry','CoShareRoot','CoSourcesRoot','InboxRoot','ArchiveRoot','PublicSnapshotsRoot')
foreach ($k in $required) { Require-Key $paths $k }

# Required existence
$regPath = $paths['PointerRegistry']
if (!(Test-Path -LiteralPath $regPath)) { throw "Required path does not exist: PointerRegistry => $regPath" }

# Warn on other paths missing (these may not exist on dev machines)
foreach ($k in @('MasterPlanLatest','CoShareRoot','CoSourcesRoot','InboxRoot','ArchiveRoot','PublicSnapshotsRoot')) {
  $p = $paths[$k]
  if (!(Test-Path -LiteralPath $p)) { Write-Warning "Path does not exist (warn): $k => $p" }
}

# --- Validate PointerRegistry
$entries = Read-JsonLines -Path $regPath
$reqFields = @('asset_id','title','canonical_uri','mirrors','version','sha256','owner','access_class','last_verified_utc')

$seen = @{}
foreach ($e in $entries) {
  foreach ($f in $reqFields) {
    if ($null -eq $e.$f -or [string]::IsNullOrWhiteSpace([string]$e.$f)) {
      throw "PointerRegistry entry missing field '$f' for asset_id='$($e.asset_id)'"
    }
  }

  $aid = [string]$e.asset_id
  $ver = [string]$e.version
  $hash = ([string]$e.sha256).ToLowerInvariant()
  if ($hash -notmatch '^[0-9a-f]{64}$') { throw "Invalid sha256 for asset_id='$aid' version='$ver': $hash" }

  if ($seen.ContainsKey($aid)) {
    $prior = $seen[$aid]
    if ([string]$prior.canonical_uri -ne [string]$e.canonical_uri) { throw "asset_id conflict: $aid has different canonical_uri values" }
    if ([string]$prior.version -eq $ver -and ([string]$prior.sha256).ToLowerInvariant() -ne $hash) {
      throw "asset_id conflict: $aid version $ver has different sha256 values"
    }
  } else {
    $seen[$aid] = $e
  }

  $target = [string]$e.canonical_uri
  if ($target.StartsWith("\\") -or $target.Contains(":\")) {
    if (!(Test-Path -LiteralPath $target)) {
      if ([string]$e.access_class -eq 'CROWN_JEWEL') { throw "CROWN_JEWEL canonical target missing: $aid => $target" }
      Write-Warning "Canonical target missing (warn): $aid => $target"
    }
  }
}

Write-Host "VALIDATE PASS: CanonicalPaths + PointerRegistry basic invariants OK."

