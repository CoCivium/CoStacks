<# CoGuardianTray (resident)
   - Creates a NotifyIcon in the Windows tray and stays alive via Application.Run().
   - Writes a local log in %USERPROFILE%\Downloads.
   - Safe: no prompts.
#>
param(
  [Parameter(Mandatory=$false)][string]$LogPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function NowUtc(){ (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ') }
function DefaultLog(){
  Join-Path $env:USERPROFILE ("Downloads\CoGuardianTray__" + (NowUtc) + ".log.txt")
}
if([string]::IsNullOrWhiteSpace($LogPath)){ $LogPath = DefaultLog }

function Log([string]$m){
  $line = ("[{0}] {1}" -f (NowUtc), $m)
  try { Add-Content -LiteralPath $LogPath -Value $line -Encoding UTF8 } catch {}
  Write-Host $line
}

Log ("START LogPath=" + $LogPath)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Build a simple icon (blue dot) so we always have *something*
$bmp = New-Object System.Drawing.Bitmap 16,16
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::DodgerBlue)
$g.FillEllipse($brush, 2,2,12,12)
$g.Dispose()
$icon = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())

$ni = New-Object System.Windows.Forms.NotifyIcon
$ni.Icon = $icon
$ni.Visible = $true
$ni.Text = "CoGuardian (tray)"

# Context menu
$menu = New-Object System.Windows.Forms.ContextMenuStrip

$miOpenLog = New-Object System.Windows.Forms.ToolStripMenuItem
$miOpenLog.Text = "Open Log"
$miOpenLog.Add_Click({
  try { Start-Process notepad.exe -ArgumentList @($LogPath) | Out-Null } catch {}
})

$miOpenFolder = New-Object System.Windows.Forms.ToolStripMenuItem
$miOpenFolder.Text = "Open Downloads"
$miOpenFolder.Add_Click({
  try { Start-Process explorer.exe -ArgumentList @((Join-Path $env:USERPROFILE "Downloads")) | Out-Null } catch {}
})

$miExit = New-Object System.Windows.Forms.ToolStripMenuItem
$miExit.Text = "Exit"
$miExit.Add_Click({
  try { Log "EXIT requested" } catch {}
  $ni.Visible = $false
  $ni.Dispose()
  [System.Windows.Forms.Application]::Exit()
})

[void]$menu.Items.Add($miOpenLog)
[void]$menu.Items.Add($miOpenFolder)
[void]$menu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))
[void]$menu.Items.Add($miExit)
$ni.ContextMenuStrip = $menu

# Double click opens log
$ni.Add_DoubleClick({ try { Start-Process notepad.exe -ArgumentList @($LogPath) | Out-Null } catch {} })

# Heartbeat timer (proves liveness)
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 60000
$timer.Add_Tick({
  try {
    $ni.Text = "CoGuardian (tray) " + (Get-Date).ToString("HH:mm")
    Log "HEARTBEAT"
  } catch {}
})
$timer.Start()

Log "RUN Application.Run()"
[System.Windows.Forms.Application]::Run()
Log "STOP (should only happen on Exit)"
