Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

param(
  [Parameter(Mandatory=$false)][string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
)

function Fail([string]$m){ throw "FAIL-CLOSED: $m" }
function Dot([string]$m){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ'), $m) }

$wdRel="tools\coguardian\watchdog\Invoke-CoGuardianWatchdog.ps1"
$wd=Join-Path $RepoRoot $wdRel
if(-not (Test-Path -LiteralPath $wd)){ Fail "Missing watchdog: $wdRel" }

$hbMarker   ="# COGUARDIAN_PATCH__WATCHDOG_HB_PARSE_LOCAL_FALLBACK__V1"
$scopeMarker="# COGUARDIAN_PATCH__WATCHDOG_STATUS_SCOPE__V1"

Dot "Patch watchdog deterministically (marker-based)"
$raw = Get-Content -LiteralPath $wd -Raw -Encoding UTF8
if($raw -notmatch [regex]::Escape($hbMarker)){ Fail "HB marker not found; refusing blind patch: $hbMarker" }

if($raw -match [regex]::Escape($scopeMarker)){
  Dot "Already patched: $scopeMarker"
  return
}

$idx = $raw.IndexOf($hbMarker, [StringComparison]::Ordinal)
if($idx -lt 0){ Fail "IndexOf failed to locate HB marker." }

$lineEnd = $raw.IndexOf("`n", $idx)
if($lineEnd -lt 0){ Fail "Could not find newline after HB marker." }

$insert = "`r`n$scopeMarker`r`n`$status = `$null  # ensure defined; do not rely on outer scope`r`n"
$raw2 = $raw.Insert($lineEnd+1, $insert)
Set-Content -LiteralPath $wd -Encoding UTF8 -Value $raw2
Dot "Patched: $wdRel"
