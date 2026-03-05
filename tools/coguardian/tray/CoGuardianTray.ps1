param(
  [Parameter(Mandatory=$false)][string]$LogPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function NowUtc(){ (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') }
function Log([string]$m){
  $line = "[{0}] {1}" -f (NowUtc), $m
  try {
    if([string]::IsNullOrWhiteSpace($LogPath)){
      $LogPath = Join-Path $env:USERPROFILE "Downloads\CoGuardianTray__ACTIVE.log.txt"
    }
    Add-Content -LiteralPath $LogPath -Value $line -Encoding UTF8
  } catch { }
}

# ---- SINGLE INSTANCE (mutex) ----
# Global\ requires admin in some contexts; use Local\ to avoid permissions.
$mutexName = "Local\CoCivium.CoGuardian.Tray"
$createdNew = $false
$mutex = $null
try {
  $mutex = [System.Threading.Mutex]::new($true, $mutexName, [ref]$createdNew)
  if(-not $createdNew){
    Log "MUTEX_ALREADY_HELD (another tray instance is running). Exiting."
    return
  }
  Log "MUTEX_ACQUIRED name=$mutexName"
} catch {
  Log ("MUTEX_ERROR " + $_.Exception.Message)
  # If mutex fails, continue (better to run than to die).
}

# ---- WINFORMS TRAY ----
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Keep references in script scope so GC can't kill the icon.
$script:NotifyIcon = New-Object System.Windows.Forms.NotifyIcon
$script:ContextMenu = New-Object System.Windows.Forms.ContextMenuStrip
$script:ExitItem    = New-Object System.Windows.Forms.ToolStripMenuItem
$script:ShowLogItem = New-Object System.Windows.Forms.ToolStripMenuItem

$script:ExitItem.Text = "Exit CoGuardian"
$script:ExitItem.Add_Click({
  try { Log "MENU_EXIT_CLICK" } catch {}
  try { [System.Windows.Forms.Application]::Exit() } catch {}
})

$script:ShowLogItem.Text = "Open Active Log"
$script:ShowLogItem.Add_Click({
  try { Log "MENU_OPEN_LOG_CLICK" } catch {}
  try {
    $p = $LogPath
    if(Test-Path -LiteralPath $p){ Start-Process notepad.exe -ArgumentList @($p) }
  } catch { }
})

[void]$script:ContextMenu.Items.Add($script:ShowLogItem)
[void]$script:ContextMenu.Items.Add($script:ExitItem)

# Choose an icon:
# Prefer a repo icon if present; otherwise fallback to SystemIcons.Information.
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) # tools\coguardian\tray -> repo
$iconCandidates = @(
  (Join-Path $repoRoot "tools\coguardian\tray\coguardian.ico"),
  (Join-Path $repoRoot "tools\coguardian\tray\CoGuardian.ico"),
  (Join-Path $repoRoot "assets\coguardian.ico")
)

$icon = $null
foreach($c in $iconCandidates){
  if(Test-Path -LiteralPath $c){
    try { $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($c); Log "ICON_FROM_FILE $c"; break } catch { }
  }
}
if(-not $icon){
  $icon = [System.Drawing.SystemIcons]::Information
  Log "ICON_FALLBACK SystemIcons.Information"
}

$script:NotifyIcon.Icon = $icon
$script:NotifyIcon.Text = "CoGuardian (running)"
$script:NotifyIcon.ContextMenuStrip = $script:ContextMenu
$script:NotifyIcon.Visible = $true

Log "NOTIFYICON_CREATED Visible=$($script:NotifyIcon.Visible)"

# Prove visibility with a balloon tip (may be suppressed by Windows settings, but log will show attempt).
try {
  $script:NotifyIcon.BalloonTipTitle = "CoGuardian"
  $script:NotifyIcon.BalloonTipText  = "CoGuardian tray started."
  $script:NotifyIcon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Info
  $script:NotifyIcon.ShowBalloonTip(2000)
  Log "BALLOONTIP_SHOWN requested=2000ms"
} catch {
  Log ("BALLOONTIP_ERROR " + $_.Exception.Message)
}

# Cleanup on exit
$onExit = {
  try { Log "APP_EXITING" } catch {}
  try {
    if($script:NotifyIcon){
      $script:NotifyIcon.Visible = $false
      $script:NotifyIcon.Dispose()
    }
  } catch { }
  try {
    if($mutex){
      $mutex.ReleaseMutex() | Out-Null
      $mutex.Dispose()
    }
  } catch { }
}
[System.Windows.Forms.Application]::add_ApplicationExit($onExit)

Log "RUN Application.Run()"
# Heartbeat timer
$script:Timer = New-Object System.Windows.Forms.Timer
$script:Timer.Interval = 60000
$script:Timer.Add_Tick({ try { Log "HEARTBEAT" } catch {} })
$script:Timer.Start()

[System.Windows.Forms.Application]::Run()