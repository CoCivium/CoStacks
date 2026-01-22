# coprime.drift_scan.ps1
# Seed-minimal drift/fork scanner.
# Usage: ./coprime.drift_scan.ps1 -PathsFile .\CanonicalPaths.yml -OutReport .\drift_report.json
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$PathsFile,
  [Parameter(Mandatory=$false)][string]$OutReport = ".\drift_report.json"
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

function Sha256File([string]$Path) {
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

$paths = Read-FlatYaml -Path $PathsFile

# Canon roots to scan (tune over time)
$roots = @()
foreach ($k in @('CoShareRoot','CoSourcesRoot','InboxRoot','ArchiveRoot','PublicSnapshotsRoot')) {
  if ($paths.Contains($k) -and (Test-Path -LiteralPath $paths[$k])) { $roots += $paths[$k] }
}

$findings = @()
$latestFiles = @()

foreach ($r in $roots) {
  $latestFiles += Get-ChildItem -LiteralPath $r -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match 'LATEST' }
}

# 1) Detect LATEST filename collisions where content differs
$latestGroups = $latestFiles | Group-Object -Property Name
foreach ($g in $latestGroups) {
  if ($g.Count -le 1) { continue }
  $hashes = $g.Group | ForEach-Object { Sha256File $_.FullName } | Select-Object -Unique
  if ($hashes.Count -gt 1) {
    $findings += [pscustomobject]@{ type="LATEST_COLLISION"; name=$g.Name; count=$g.Count; paths=($g.Group.FullName); hashes=$hashes }
  }
}

# 2) Duplicate basenames with different hashes (common shadow-fork symptom)
$allFiles = @()
foreach ($r in $roots) {
  $allFiles += Get-ChildItem -LiteralPath $r -Recurse -File -ErrorAction SilentlyContinue
}
$baseGroups = $allFiles | Group-Object -Property Name
foreach ($g in $baseGroups) {
  if ($g.Count -le 1) { continue }
  $hashes = $g.Group | ForEach-Object { Sha256File $_.FullName } | Select-Object -Unique
  if ($hashes.Count -gt 1) {
    $findings += [pscustomobject]@{ type="DUPLICATE_BASENAME_DIFFERENT_CONTENT"; name=$g.Name; count=$g.Count; paths=($g.Group.FullName); hashes=$hashes }
  }
}

$report = [pscustomobject]@{
  generated_utc = (Get-Date).ToUniversalTime().ToString("o")
  roots_scanned = $roots
  finding_count = $findings.Count
  findings = $findings
}

$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $OutReport -Encoding UTF8

if ($findings.Count -gt 0) {
  Write-Host "DRIFT_SCAN FAIL: $($findings.Count) findings. Report=$OutReport"
  exit 2
} else {
  Write-Host "DRIFT_SCAN PASS: no findings. Report=$OutReport"
  exit 0
}
