Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Log([string]$m){
  try{
    $p = Join-Path $env:LOCALAPPDATA 'CoCivium\CoGuardian\watchdog.log'
    $dir = Split-Path $p -Parent
    if(-not (Test-Path -LiteralPath $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $ts=(Get-Date).ToUniversalTime().ToString('o')
    Add-Content -LiteralPath $p -Encoding UTF8 -Value ("[{0}] {1}" -f $ts,$m)
  } catch {}
}

function ParseUtc([string]$s){
  if([string]::IsNullOrWhiteSpace($s)){ return $null }
  try { return [DateTime]::Parse($s, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AssumeUniversal).ToUniversalTime() } catch { return $null }
}

try {
  $status = Join-Path $env:LOCALAPPDATA 'CoCivium\CoGuardian\status.json'
  $boot   = Join-Path $env:LOCALAPPDATA 'CoCivium\CoGuardian\cache\CoGuardianTray_Bootstrap.ps1'
  $fallbackBoot = Join-Path '\\Server\CoCiviumAdmin\CoVault\CoCiviumAdmin\_Work\repos\CoStacks' 'tools\coguardian\tray\CoGuardianTray_Bootstrap.ps1'

  $now = (Get-Date).ToUniversalTime()
  $maxAgeSec = 120

  $trayScript = $null
  $hbUtc = $null

  if(Test-Path -LiteralPath $status){
    try{
      $st = Get-Content -LiteralPath $status -Raw -Encoding UTF8 | ConvertFrom-Json
      $trayScript = [string]$st.TrayScript
      $hbUtc = ParseUtc ([string]$st.LastHeartbeatUTC)
    } catch {
      Log ("STATUS_PARSE_FAIL: " + $_.Exception.Message)
    }
  } else {
    Log "STATUS_MISSING"
  }

  $hbAge = $null
  if($hbUtc){
    $hbAge = [int]([Math]::Floor(($now - $hbUtc).TotalSeconds))
  }

  # Is tray process running?
  $trayRunning = $false
  if($trayScript -and (Test-Path -LiteralPath $trayScript)){
    try {
      $p = Get-CimInstance Win32_Process |
        Where-Object { ($_.Name -in @('pwsh.exe','powershell.exe')) -and ($_.CommandLine -match [regex]::Escape($trayScript)) } |
        Select-Object -First 1
      if($p){ $trayRunning = $true }
    } catch {}
  }

  $needRestart = $false
  if(-not $trayRunning){ $needRestart = $true }
  if(-not $hbUtc){ $needRestart = $true }
  if($hbAge -ne $null -and $hbAge -gt $maxAgeSec){ $needRestart = $true }

  if(-not $needRestart){
    # quiet success
    return
  }

  Log ("RESTART_NEEDED trayRunning={0} hbUtc={1} hbAgeSec={2}" -f $trayRunning,$hbUtc,$hbAge)

  # Choose bootstrap path
  $useBoot = $null
  if(Test-Path -LiteralPath $boot){ $useBoot = $boot }
  elseif(Test-Path -LiteralPath $fallbackBoot){ $useBoot = $fallbackBoot }

  if(-not $useBoot){
    Log "BOOTSTRAP_MISSING (no cache bootstrap and no repo bootstrap)"
    return
  }

  Start-Process "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -WindowStyle Hidden -ArgumentList @(
    "-NoProfile","-WindowStyle","Hidden","-ExecutionPolicy","Bypass",
    "-File",$useBoot
  ) | Out-Null

  Log ("RELAUNCHED via " + $useBoot)
} catch {
  try { Log ("WATCHDOG_FAIL: " + $_.Exception.Message) } catch {}
}
