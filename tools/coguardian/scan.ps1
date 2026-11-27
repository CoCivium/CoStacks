param(
  [Parameter(Mandatory=$true)][string]$CoBusMirrorSha,
  [Parameter(Mandatory=$false)][int]$MaxSubs = 100,
  [Parameter(Mandatory=$false)][string]$OutPath = "docs/COHEALTH__LATEST.md"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function UTS { (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') }

function Fetch([string]$url){
  try { return [pscustomobject]@{ Content=(Invoke-WebRequest -Uri $url -TimeoutSec 20).Content; Kind='FETCHED' } }
  catch {
    $code = $null
    $response = $_.Exception.PSObject.Properties['Response']
    if ($null -ne $response -and $null -ne $response.Value) {
      $status = $response.Value.PSObject.Properties['StatusCode']
      if ($null -ne $status) { $code = [int]$status.Value }
    }
    if ($code -eq 404) { return [pscustomobject]@{ Content=$null; Kind='NOT_FOUND' } }
    return [pscustomobject]@{ Content=$null; Kind='FETCH_ERROR' }
  }
}

$utc = UTS
$rawBase = "https://raw.githubusercontent.com/CoCivium/CoBusMirror/$CoBusMirrorSha"

$rawCoPre  = "$rawBase/docs/COBUS_LITE/canon/COPRE_SUBSESSION__LATEST.md"
$rawIndex  = "$rawBase/docs/COBUS_LITE/canon/WAVESET_SUBSESSIONS_INDEX__LATEST.md"
$coPreTxt  = (Fetch $rawCoPre).Content
$idxTxt    = (Fetch $rawIndex).Content

$rows = New-Object System.Collections.Generic.List[object]
for($i=1; $i -le $MaxSubs; $i++){
  $sid = "Sub{0}" -f $i
  $busUrl = "$rawBase/docs/COBUS_LITE/bus/subsessions/${sid}__LATEST.md"
  $fetched = Fetch $busUrl
  $txt = $fetched.Content

  if($fetched.Kind -ne 'FETCHED'){
    $rows.Add([pscustomobject]@{ Sub=$sid; Status=$fetched.Kind; LastUTC=""; LastState=""; Url=$busUrl })
    continue
  }

  $lastUtc = ""
  $lastState = ""

  $mUtc = [regex]::Matches($txt, 'UTC=([0-9]{8}T[0-9]{6}Z)')
  if($mUtc.Count -gt 0){ $lastUtc = $mUtc[$mUtc.Count-1].Groups[1].Value }

  $mSt = [regex]::Matches($txt, 'STATE=([a-zA-Z0-9_\-]+)')
  if($mSt.Count -gt 0){ $lastState = $mSt[$mSt.Count-1].Groups[1].Value }

  $status = "FIELDS_PRESENT_FRESHNESS_UNKNOWN"
  if([string]::IsNullOrWhiteSpace($lastUtc)){ $status = "NEEDS_UTC" }
  elseif([string]::IsNullOrWhiteSpace($lastState)){ $status = "NEEDS_STATE" }

  $rows.Add([pscustomobject]@{ Sub=$sid; Status=$status; LastUTC=$lastUtc; LastState=$lastState; Url=$busUrl })
}

$out = New-Object System.Collections.Generic.List[string]
$out.Add("# COHEALTH__LATEST")
$out.Add("")
$out.Add("> Shadow-mode CoGuardian v0 (report-only).")
$out.Add("")
$out.Add("- GENERATED_UTC=$utc")
$out.Add("- INPUT_COBUSMIRROR_SHA=$CoBusMirrorSha")
$out.Add("- INPUT_RAW_BASE=$rawBase")
$out.Add("- RAW_COPRE=$rawCoPre")
$out.Add("- RAW_INDEX=$rawIndex")
$out.Add("")
$fields = @($rows | Where-Object { $_.Status -eq "FIELDS_PRESENT_FRESHNESS_UNKNOWN" }).Count
$notFound = @($rows | Where-Object { $_.Status -eq "NOT_FOUND" }).Count
$fetchError = @($rows | Where-Object { $_.Status -eq "FETCH_ERROR" }).Count
$need = @($rows | Where-Object { $_.Status -like "NEEDS_*" }).Count
$out.Add("## Summary")
$out.Add("- FIELDS_PRESENT_FRESHNESS_UNKNOWN=$fields")
$out.Add("- NEEDS_FIELDS=$need")
$out.Add("- NOT_FOUND=$notFound")
$out.Add("- FETCH_ERROR=$fetchError")
$out.Add("- LIVENESS=UNPROVEN (no heartbeat lease or runtime check)")
$out.Add("")
$out.Add("## Subsessions")
$out.Add("")
$out.Add("| Sub | Status | LastUTC | LastState | RAW |")
$out.Add("|---|---|---|---|---|")
foreach($r in $rows){
  $out.Add("| $($r.Sub) | $($r.Status) | $($r.LastUTC) | $($r.LastState) | $($r.Url) |")
}

$outDir = Split-Path -Parent $OutPath
if($outDir -and -not (Test-Path -LiteralPath $outDir)){ New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
($out -join "
") | Set-Content -LiteralPath $OutPath -Encoding UTF8
Write-Host "OK: wrote $OutPath"



