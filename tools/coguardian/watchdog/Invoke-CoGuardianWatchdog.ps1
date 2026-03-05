# COGUARDIAN_PATCH__WATCHDOG_REJECT_NEGATIVE_AGE__V1
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function NowUtc { (Get-Date).ToUniversalTime() }
function J([object]$o){ $o | ConvertTo-Json -Depth 8 }

$root = Join-Path $env:LOCALAPPDATA "CoCivium\CoGuardian"
New-Item -ItemType Directory -Force -Path $root | Out-Null

$log = Join-Path $root "watchdog.log"
$statusPath = Join-Path $root "status.json"
$quarantinePath = Join-Path $root "watchdog_quarantine.json"
$diagDir = Join-Path $root "diag"
New-Item -ItemType Directory -Force -Path $diagDir | Out-Null

function Log([string]$msg){
  try {
    $ts = (NowUtc).ToString('o')
    Add-Content -LiteralPath $log -Encoding UTF8 -Value ("[{0}] {1}" -f $ts, $msg)
  } catch { }
}

# Policy knobs
$MaxHeartbeatAgeSec = 120
$MaxRestartsInWindow = 5
$WindowMinutes = 10
$QuarantineMinutes = 30

function InQuarantine {
  if(-not (Test-Path -LiteralPath $quarantinePath)){ return $false }
  try {
    $q = Get-Content -LiteralPath $quarantinePath -Raw -Encoding UTF8 | ConvertFrom-Json
    if(-not $q.UntilUTC){ return $false }
    $until = [datetime]::Parse($q.UntilUTC).ToUniversalTime()
    return ((NowUtc) -lt $until)
  } catch { return $false }
}

function EnterQuarantine([string]$reason){
  try {
    $until = (NowUtc).AddMinutes($QuarantineMinutes).ToString('o')
    $obj = [ordered]@{
      EnteredUTC=(NowUtc).ToString('o')
      UntilUTC=$until
      Reason=$reason
    }
    $obj | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $quarantinePath -Encoding UTF8
    Log ("QUARANTINE Entered until {0} Reason={1}" -f $until,$reason)
  } catch { }
}

function RestartBudgetOk {
  # Track restarts in a rolling window
  $histPath = Join-Path $root "watchdog_restart_history.json"
  $now = NowUtc
  $cut = $now.AddMinutes(-1*$WindowMinutes)

  $items=@()
  if(Test-Path -LiteralPath $histPath){
    try { $items = @(Get-Content -LiteralPath $histPath -Raw -Encoding UTF8 | ConvertFrom-Json) } catch { $items=@() }
  }
  # keep only recent
  $items = @($items | Where-Object {
    try { ([datetime]::Parse($_.UTC).ToUniversalTime() -ge $cut) } catch { $false }
  })
  if(@($items).Count -ge $MaxRestartsInWindow){
    EnterQuarantine ("Restart limit exceeded: {0} in {1}m" -f @($items).Count,$WindowMinutes)
    return $false
  }
  # append pending restart marker
  $items = @($items + ([pscustomobject]@{ UTC=$now.ToString('o') }))
  try { $items | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $histPath -Encoding UTF8 } catch { }
  return $true
}

function GetStatus {
  if(-not (Test-Path -LiteralPath $statusPath)){ return $null }
  try { return (Get-Content -LiteralPath $statusPath -Raw -Encoding UTF8 | ConvertFrom-Json) } catch { return $null }
}

function TrayProcessOk([string]$trayScriptPath){
  if(-not $trayScriptPath){ return $false }
  try {
    $cands = Get-CimInstance Win32_Process |
      Where-Object {
        ($_.Name -in @('pwsh.exe','powershell.exe')) -and
        ($_.CommandLine -match [regex]::Escape($trayScriptPath))
      }
    return (@($cands).Count -ge 1)
  } catch { return $false }
}

function StartBootstrap {
  $boot = Join-Path $PSScriptRoot "..\tray\CoGuardianTray_Bootstrap.ps1" | Resolve-Path -ErrorAction SilentlyContinue
  if(-not $boot){ throw "Missing bootstrap (relative): tools\coguardian\tray\CoGuardianTray_Bootstrap.ps1" }
  $ps1 = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
  Start-Process $ps1 -WindowStyle Hidden -ArgumentList @(
    "-NoProfile","-WindowStyle","Hidden","-ExecutionPolicy","Bypass",
    "-File",$boot.Path
  ) | Out-Null
}

Log "TICK"

if(InQuarantine){
  Log "QUARANTINE Active: skipping restart attempts."
  return
}

$st = GetStatus
if(-not $st){
  Log "STATUS Missing/unreadable; will attempt bootstrap restart."
  if(RestartBudgetOk){
    try { StartBootstrap; Log "RESTART bootstrap (reason=status-missing)"; } catch { Log ("RESTART_FAIL " + $_.Exception.Message) }
  }
  return
}

# Heartbeat freshness
$hbOk=$false
try {
  if($st.LastHeartbeatUTC){
    $hb=[datetime]::Parse([string]$st.LastHeartbeatUTC).ToUniversalTime()
    $age=((NowUtc)-$hb).TotalSeconds
    if(($age -ge 0) -and ($age -le $MaxHeartbeatAgeSec)){ $hbOk=$true } else { if($age -lt 0){ Log ("CLOCK_SKEW heartbeat-in-future ageSec=" + $age) } }
    Log ("HB ageSec={0:n1} ok={1}" -f $age,$hbOk)
  } else {
    Log "HB missing in status.json"
  }
} catch {
  Log ("HB parse error: " + $_.Exception.Message)
}

$trayOk = TrayProcessOk ([string]$st.TrayScript)
Log ("TRAY_PROCESS ok={0} TrayScript={1}" -f $trayOk,[string]$st.TrayScript)

if($hbOk -and $trayOk){
  return
}

# Attempt restart
if(-not (RestartBudgetOk)){ return }

try {
  StartBootstrap
  Log ("RESTART bootstrap (reason=hbOk:{0} trayOk:{1})" -f $hbOk,$trayOk)
} catch {
  Log ("RESTART_FAIL " + $_.Exception.Message)
  # write a small diag snapshot
  try {
    $utc=(NowUtc).ToString("yyyyMMddTHHmmssZ")
    $diag = Join-Path $diagDir "DIAG__WATCHDOG_RESTART_FAIL__${utc}.txt"
    @(
      "UTC=$utc"
      "Reason=RestartFail"
      "TrayScript=$([string]$st.TrayScript)"
      "LastHeartbeatUTC=$([string]$st.LastHeartbeatUTC)"
      "Error=$($_.Exception.Message)"
    ) | Set-Content -LiteralPath $diag -Encoding UTF8
  } catch { }
}

