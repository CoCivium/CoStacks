param(
  [Parameter(Mandatory=$false)]
  [string]$PathsFile = (Join-Path (Split-Path $PSScriptRoot -Parent) 'CanonicalPaths.yml')
)

$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest

function Fail([string]$msg){
  Write-Error $msg
  exit 1
}

if(!(Test-Path -LiteralPath $PathsFile)){
  Fail "Missing PathsFile: $PathsFile"
}

# Minimal YAML (Key: Value) parser for CanonicalPaths.yml (no external modules)
$map = @{}
$i = 0
foreach($line in (Get-Content -LiteralPath $PathsFile -Encoding UTF8)){
  $i++
  $t = ($line -replace '#.*$','').Trim()
  if([string]::IsNullOrWhiteSpace($t)){ continue }

  if($t -notmatch '^(?<k>[A-Za-z0-9_]+)\s*:\s*(?<v>.+)$'){
    Fail "CanonicalPaths parse error at line ${i}: $line"
  }
  $k = $matches['k']
  $v = $matches['v'].Trim()

  if($v -match '^"(.*)"$'){ $v = $matches[1] }
  if($v -match "^'(.*)'$"){ $v = $matches[1] }

  $map[$k] = $v
}

$required = @(
  'MasterPlanLatest',
  'PointerRegistry',
  'CoShareRoot',
  'CoSourcesRoot',
  'InboxRoot',
  'ArchiveRoot',
  'PublicSnapshotsRoot'
)

foreach($k in $required){
  if(-not $map.ContainsKey($k) -or [string]::IsNullOrWhiteSpace([string]$map[$k])){
    Fail "CanonicalPaths missing required key: $k"
  }
}

$root = Split-Path -Parent $PathsFile

# Files referenced inside repo must exist
$mp = Join-Path $root $map['MasterPlanLatest']
if(!(Test-Path -LiteralPath $mp)){
  Fail "MasterPlanLatest missing: $mp"
}

$pr = Join-Path $root $map['PointerRegistry']
if(!(Test-Path -LiteralPath $pr)){
  Fail "PointerRegistry missing: $pr"
}

# PointerRegistry must be JSONL (ignore blanks + #comments)
$j = 0
foreach($line in (Get-Content -LiteralPath $pr -Encoding UTF8)){
  $j++
  $t = $line.Trim()
  if([string]::IsNullOrWhiteSpace($t)){ continue }
  if($t.StartsWith('#')){ continue }

  try { $obj = $t | ConvertFrom-Json -ErrorAction Stop }
  catch { Fail "PointerRegistry JSON parse error at line ${j}: $($_.Exception.Message)" }

  foreach($rk in @('id','url','kind')){
    $has = ($obj.PSObject.Properties.Name -contains $rk) -and -not [string]::IsNullOrWhiteSpace([string]$obj.$rk)
    if(-not $has){ Fail "PointerRegistry missing field '$rk' at line ${j}" }
  }
}

# Optional schema JSON validity check
$schema = Join-Path $root 'schemas\PointerRegistryEntry.schema.json'
if(Test-Path -LiteralPath $schema){
  try { (Get-Content -LiteralPath $schema -Raw -Encoding UTF8) | ConvertFrom-Json -ErrorAction Stop | Out-Null }
  catch { Fail "Schema JSON invalid: $schema :: $($_.Exception.Message)" }
}

Write-Host "VALIDATE PASS"
