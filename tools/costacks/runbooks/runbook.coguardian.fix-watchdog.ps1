param([Parameter(Mandatory=$true)]$Context)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Dot([string]$m){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString("HH:mm:ssZ"), $m) }
function Fail([string]$m){ throw "FAIL-CLOSED: $m" }

$repo = $Context.RepoRoot
$taskName = $Context.TaskName

$wdRel   ="tools\coguardian\watchdog\Invoke-CoGuardianWatchdog.ps1"
$instRel ="tools\coguardian\watchdog\Install-CoGuardianWatchdogTask.ps1"
$renewRel="tools\coguardian\watchdog\Renew-CoGuardianWatchdogTask.ps1"
$verRel  ="tools\coguardian\watchdog\Verify-CoGuardianWatchdogTask.ps1"

$wd   = Join-Path $repo $wdRel
$inst = Join-Path $repo $instRel
$renew= Join-Path $repo $renewRel
$ver  = Join-Path $repo $verRel

foreach($p in @($wd,$inst,$renew,$ver)){
  if(-not (Test-Path -LiteralPath $p)){ Fail "Missing required file: $p" }
}

Dot "Runbook: coguardian.fix-watchdog"

# 1) Patch watchdog: ensure $status defined (marker-based, no regex dialect footguns)
$hbMarker   ="# COGUARDIAN_PATCH__WATCHDOG_HB_PARSE_LOCAL_FALLBACK__V1"
$scopeMarker="# COGUARDIAN_PATCH__WATCHDOG_STATUS_SCOPE__V1"

if($Context.Apply){
  $raw = Get-Content -LiteralPath $wd -Raw -Encoding UTF8
  if($raw -notmatch [regex]::Escape($hbMarker)){ Fail "HB marker not found; refusing blind patch: $hbMarker" }

  if($raw -notmatch [regex]::Escape($scopeMarker)){
    $idx = $raw.IndexOf($hbMarker, [StringComparison]::Ordinal)
    if($idx -lt 0){ Fail "IndexOf failed locating HB marker." }
    $lineEnd = $raw.IndexOf("`n", $idx)
    if($lineEnd -lt 0){ Fail "No newline after HB marker." }
    $insert = "`r`n$scopeMarker`r`n`$status = `$null  # ensure defined; do not rely on outer scope`r`n"
    $raw2 = $raw.Insert($lineEnd+1, $insert)
    Set-Content -LiteralPath $wd -Encoding UTF8 -Value $raw2
    Dot "Patched watchdog status scope."
  } else {
    Dot "Watchdog already has status-scope marker."
  }

  # 2) Patch installer: dedupe -WindowStyle Hidden occurrences
  $instRaw = Get-Content -LiteralPath $inst -Raw -Encoding UTF8
  $instMarker="# COGUARDIAN_PATCH__INSTALLER_DEDUPE_WINDOWSTYLE_HIDDEN__V1"
  if($instRaw -notmatch [regex]::Escape($instMarker)){
    $instRaw2 = $instRaw

    $instRaw2 = [regex]::Replace(
      $instRaw2,
      '(?im)-WindowStyle\s+Hidden\s+-NoProfile\s+-WindowStyle\s+Hidden',
      '-WindowStyle Hidden -NoProfile'
    )
    $instRaw2 = [regex]::Replace($instRaw2, '(?im)(-WindowStyle\s+Hidden)(\s+-WindowStyle\s+Hidden)+', '$1')
    $instRaw2 = [regex]::Replace($instRaw2, '(?im)(-WindowStyle\s+Hidden)(\s+-WindowStyle\s+Hidden)+', '$1')

    $instRaw2 = $instMarker + "`r`n" + $instRaw2
    Set-Content -LiteralPath $inst -Encoding UTF8 -Value $instRaw2
    Dot "Patched installer hidden-args dedupe."
  } else {
    Dot "Installer already has hidden-args dedupe marker."
  }
}

# 3) Renew + verify + re-enable task only after verify succeeds
if($Context.Apply){
  Dot "Renew watchdog task (reinstall)"
  & $renew | Out-Host
}

if($Context.Verify){
  Dot "Verify watchdog task"
  $out = & $ver
  $out | ForEach-Object { Write-Host $_ }

  # Hard checks
  $q = & schtasks /Query /TN $taskName /V /FO LIST 2>&1
  $qText = ($q -join "`n")

  if($qText -notmatch 'Status:\s+Ready'){ Fail "Task not Ready per schtasks." }
  if($qText -notmatch 'Task To Run:.*pwsh\.exe'){ Fail "Task To Run does not reference pwsh.exe." }
  if($qText -match '-WindowStyle Hidden -NoProfile -WindowStyle Hidden'){ Fail "Hidden args still duplicated in task definition." }

  Dot "Re-enable watchdog task"
  Enable-ScheduledTask -TaskName $taskName | Out-Null

  Dot "Wait ~80s for a tick then tail watchdog.log (last 80)"
  Start-Sleep -Seconds 80
  $cgDir = Join-Path $env:LOCALAPPDATA "CoCivium\CoGuardian"
  $wdLog = Join-Path $cgDir "watchdog.log"
  if(Test-Path -LiteralPath $wdLog){
    $tail = Get-Content -LiteralPath $wdLog -Tail 80
    $tail | Out-Host
    if($tail -match "variable '\$status' cannot be retrieved because it has not been set"){ Fail "Still seeing status-scope error in log." }
    if($tail -match "HB ageSec=.* ok=True" -and $tail -match "CLOCK_SKEW"){ Fail "Clock skew still causing ok=True (should be ok=False after patch)." }
  } else {
    Fail "No watchdog.log found at $wdLog"
  }
}

