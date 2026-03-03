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
  try { return (Invoke-WebRequest -Uri $url -TimeoutSec 20).Content }
  catch { return $null }
}

$utc = UTS
$rawBase = "https://raw.githubusercontent.com/CoCivium/CoBusMirror/$CoBusMirrorSha"

$rawCoPre  = "$rawBase/docs/COBUS_LITE/canon/COPRE_SUBSESSION__LATEST.md"
$rawIndex  = "$rawBase/docs/COBUS_LITE/canon/WAVESET_SUBSESSIONS_INDEX__LATEST.md"
$coPreTxt  = Fetch $rawCoPre
$idxTxt    = Fetch $rawIndex

$rows = New-Object System.Collections.Generic.List[object]
for($i=1; $i -le $MaxSubs; $i++){
  $sid = "Sub{0}" -f $i
  $busUrl = "$rawBase/docs/COBUS_LITE/bus/subsessions/${sid}__LATEST.md"
  $txt = Fetch $busUrl

  if(-not $txt){
    $rows.Add([pscustomobject]@{ Sub=$sid; Status="MISSING/UNFETCHABLE"; LastUTC=""; LastState=""; Url=$busUrl })
    continue
  }

  $lastUtc = ""
  $lastState = ""

  $mUtc = [regex]::Matches($txt, 'UTC=([0-9]{8}T[0-9]{6}Z)')
  if($mUtc.Count -gt 0){ $lastUtc = $mUtc[$mUtc.Count-1].Groups[1].Value }

  $mSt = [regex]::Matches($txt, 'STATE=([a-zA-Z0-9_\-]+)')
  if($mSt.Count -gt 0){ $lastState = $mSt[$mSt.Count-1].Groups[1].Value }

  $status = "OK"
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
$ok = @($rows | Where-Object { $_.Status -eq "OK" }).Count
$miss = @($rows | Where-Object { $_.Status -like "MISSING*" }).Count
$need = @($rows | Where-Object { $_.Status -ne "OK" -and $_.Status -notlike "MISSING*" }).Count
$out.Add("## Summary")
$out.Add("- OK=$ok")
$out.Add("- NEEDS_FIELDS=$need")
$out.Add("- MISSING_OR_UNFETCHABLE=$miss")
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



