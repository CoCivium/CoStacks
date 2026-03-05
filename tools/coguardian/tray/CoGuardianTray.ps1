# COGUARDIAN_PATCH__NO_CONSOLE_SCANMENU__V1
function CoGuardian_OpenLocalFolder {
  try {
    $p = Join-Path $env:LOCALAPPDATA 'CoCivium\CoGuardian'
    if(-not (Test-Path -LiteralPath $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null }
    Start-Process explorer.exe -ArgumentList @(""$p"") | Out-Null
  } catch {
    try { [System.Windows.Forms.MessageBox]::Show("CoGuardian: couldn't open local folder. Path: $env:LOCALAPPDATA\CoCivium\CoGuardian","CoGuardian") | Out-Null } catch {}
  }
}

# CoGuardianTray.ps1 - minimal visible system-tray surface for CoStacks (MVP)
## COGuardianTray.SingletonMutex
## COGuardianTray.StatusJsonTelemetry.EARLY
# EARLY telemetry: must run before any blocking UI/message loop.
# Writes: %LOCALAPPDATA%\CoCivium\CoGuardian\status.json (and refreshes on timer)
try {
  if(-not (Get-Variable -Name CoGuardian_State -Scope Script -ErrorAction SilentlyContinue)){
    Set-Variable -Name CoGuardian_State -Scope Script -Value "OK"
  }
  if(-not (Get-Variable -Name CoGuardian_LastErrorUTC -Scope Script -ErrorAction SilentlyContinue)){
    Set-Variable -Name CoGuardian_LastErrorUTC -Scope Script -Value ""
  }

  function Write-CoGuardianStatusJson {
    param(
      [string]$State = $script:CoGuardian_State,
      [string]$LastErrorUTC = $script:CoGuardian_LastErrorUTC
    )
    try {
      $utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
      $dir = Join-Path $env:LOCALAPPDATA "CoCivium\CoGuardian"
      New-Item -ItemType Directory -Force -Path $dir | Out-Null
      $path = Join-Path $dir "status.json"
      $obj = [ordered]@{
        State = $State
        LastHeartbeatUTC = $utc
        LastErrorUTC = $LastErrorUTC
        Host = $env:COMPUTERNAME
        User = $env:USERNAME
        PID  = $PID
        TrayScript = $PSCommandPath
      }
      ($obj | ConvertTo-Json -Depth 3) | Set-Content -Encoding UTF8 -LiteralPath $path
    } catch {}
  }

  # Write once immediately.
  Write-CoGuardianStatusJson

  # Heartbeat timer (doesn't depend on HttpListener, firewall, or URLACL).
  if(-not (Get-Variable -Name __CoGuardianStatusTimer -Scope Script -ErrorAction SilentlyContinue)){
    $script:__CoGuardianStatusTimer = New-Object System.Timers.Timer
    $script:__CoGuardianStatusTimer.Interval = 5000
    $script:__CoGuardianStatusTimer.AutoReset = $true
    $null = Register-ObjectEvent -InputObject $script:__CoGuardianStatusTimer -EventName Elapsed -Action { try { Write-CoGuardianStatusJson } catch {} } -ErrorAction SilentlyContinue
    $script:__CoGuardianStatusTimer.Start()
  }
} catch {}
## COGuardianTray.LocalStatusAPI_v0
# --- Minimal diagnostic core (v0) ---
# Goals:
#  - Provide a stable heartbeat + tooltip fields for screenshots/diagnosis.
#  - Provide a tiny localhost status endpoint for future CoGuard extension handshake.
# Notes:
#  - Keep this lightweight; do not block UI thread; degrade gracefully if listener fails.

$script:CoGuardian = [ordered]@{
  SessionLabel      = 
  Role              = 
  StartedUTC        = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
  LastHeartbeatUTC  = 
  LastErrorUTC      = 
  State             = 'OK'     # OK|WARN|FAIL
  Activity          = False
  LastNote          = 'boot'
  VersionTag        = 'v0'
}

function Set-CoGState {
  param([ValidateSet('OK','WARN','FAIL')][string]$State, [string]$Note = '')
  $script:CoGuardian.State = $State
  if($Note){ $script:CoGuardian.LastNote = $Note }
}

function Touch-Heartbeat {
  $script:CoGuardian.LastHeartbeatUTC = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
}

function Touch-Error {
  $script:CoGuardian.LastErrorUTC = (Get-Date).ToUniversalTime().ToString('yyyyMMddTHHmmssZ')
  Set-CoGState -State 'FAIL' -Note 'error'
}

# Local status endpoint (read-only): http://127.0.0.1:17777/status
# Returns JSON snapshot of $script:CoGuardian
function Start-CoGStatusListener {
  try {
    $listener = [System.Net.HttpListener]::new()
    $listener.Prefixes.Add('http://127.0.0.1:17777/')
    $listener.Start()

    $null = [System.Threading.ThreadPool]::QueueUserWorkItem({
      param($l)
      while($l.IsListening){
        try {
          $ctx = $l.GetContext()
          $path = $ctx.Request.Url.AbsolutePath
          if($path -eq '/status'){
            $ctx.Response.StatusCode = 200
            $ctx.Response.ContentType = 'application/json; charset=utf-8'
            $body = ($script:CoGuardian | ConvertTo-Json -Depth 4)
          } else {
            $ctx.Response.StatusCode = 404
            $ctx.Response.ContentType = 'text/plain; charset=utf-8'
            $body = 'not found'
          }
          $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
          $ctx.Response.OutputStream.Write($bytes,0,$bytes.Length)
          $ctx.Response.OutputStream.Close()
        } catch {
          # keep looping; do not kill tray
          try { Touch-Error } catch {}
        }
      }
    }, $listener) | Out-Null

    return $listener
  } catch {
    # Listener is optional. If blocked, we still run tray.
    try { Set-CoGState -State 'WARN' -Note 'listener blocked' } catch {}
    return $null
  }
}

# Tooltip builder (must be short-ish, but diagnostic)
function Get-CoGTooltip {
  $sl = if([string]::IsNullOrWhiteSpace($script:CoGuardian.SessionLabel)){'(no COS_SESSION_LABEL)'}else{$script:CoGuardian.SessionLabel}
  $rl = if([string]::IsNullOrWhiteSpace($script:CoGuardian.Role)){'(no COS_ROLE)'}else{$script:CoGuardian.Role}
  return ("CoGuardian {0} | {1} | {2} | HB={3} | ERR={4} | {5}" -f
    $script:CoGuardian.VersionTag,
    $sl,
    $rl,
    ($script:CoGuardian.LastHeartbeatUTC ?? 'never'),
    ($script:CoGuardian.LastErrorUTC ?? 'none'),
    ($script:CoGuardian.State + (if($script:CoGuardian.Activity){' +ACT'}else{''}))
  )
}
# --- End minimal diagnostic core (v0) ---
# Single-instance guard: if another tray instance is running, exit immediately.
# Global namespace reduces duplicates across sessions/users on the same box.
$__CoGuardianTrayMutexName = 'Global\CoCivium.CoGuardianTray'
try {
  $__createdNew = $false
  $__mutex = [System.Threading.Mutex]::new($true, $__CoGuardianTrayMutexName, [ref]$__createdNew)
  if(-not $__createdNew){
    # Another instance already holds the mutex
    return
  }
} catch {
  # If mutex fails, continue rather than hard-fail, but duplication risk remains.
}
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$repoTop = (git rev-parse --show-toplevel 2>$null)
if(-not $repoTop){ $repoTop = (Get-Location).Path }

$icoPath = Join-Path $repoTop 'tools\coguardian\extension_mv3\icons\icon.ico'
$ico = $null
try { if(Test-Path -LiteralPath $icoPath){ $ico = New-Object System.Drawing.Icon($icoPath) } } catch { }

$ni = New-Object System.Windows.Forms.NotifyIcon
$ni.Text = 'CoGuardian (CoStacks)'
if($ico){ $ni.Icon = $ico }
$ni.Visible = $true
$ni.BalloonTipTitle = 'CoGuardian'
$ni.BalloonTipText = 'Running. Right-click for actions.'
$ni.ShowBalloonTip(1500)

$menu = New-Object System.Windows.Forms.ContextMenuStrip

$mi1 = New-Object System.Windows.Forms.ToolStripMenuItem 'Open COHEALTH (GitHub)'
$mi1.add_Click({ Start-Process 'https://github.com/CoCivium/CoStacks/blob/main/docs/COHEALTH__LATEST.md' })
[void]$menu.Items.Add($mi1)

$mi2 = New-Object System.Windows.Forms.ToolStripMenuItem 'Open CoStacks Repo (GitHub)'
$mi2.add_Click({ Start-Process 'https://github.com/CoCivium/CoStacks' })
[void]$menu.Items.Add($mi2)

$mi3 = New-Object System.Windows.Forms.ToolStripMenuItem 'Open CoGuardian folder (local)'
$mi3.add_Click({
  try {
    $scan = Join-Path $repoTop 'tools\coguardian\scan.ps1'
    if(Test-Path -LiteralPath $scan){
      $shaFile = Join-Path $repoTop 'docs\COBUSMIRROR_SHA__LATEST.txt'
$sha = $null
try { if(Test-Path -LiteralPath $shaFile){ $sha = (Get-Content -LiteralPath $shaFile -TotalCount 1).Trim() } } catch { }
if(-not $sha){
  [System.Windows.Forms.MessageBox]::Show("Missing CoBusMirror SHA. Expected: $shaFile")
} else {
  Start-Process pwsh -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',$scan,'-CoBusMirrorSha',$sha) -WorkingDirectory $repoTop
}
    } else {
      [System.Windows.Forms.MessageBox]::Show("scan.ps1 not found at: $scan")
    }
  } catch {
    [System.Windows.Forms.MessageBox]::Show("Error: " + $_.Exception.Message)
  }
})
[void]$menu.Items.Add($mi3)

[void]$menu.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))

$miX = New-Object System.Windows.Forms.ToolStripMenuItem 'Exit CoGuardian'
$miX.add_Click({
  $ni.Visible = $false
  $ni.Dispose()
  [System.Windows.Forms.Application]::Exit()
})
[void]$menu.Items.Add($miX)

$ni.ContextMenuStrip = $menu
[System.Windows.Forms.Application]::Run()
## COGuardianTray.HeartbeatTimer_v0
try {
  # Start listener first (optional)
  if(-not $script:__CoGListener){ $script:__CoGListener = Start-CoGStatusListener }
  # Heartbeat timer
  if(-not $script:__CoGHeartbeatTimer){
    $script:__CoGHeartbeatTimer = New-Object System.Timers.Timer
    $script:__CoGHeartbeatTimer.Interval = 5000
    $script:__CoGHeartbeatTimer.AutoReset = $true
    $script:__CoGHeartbeatTimer.add_Elapsed({ try { Touch-Heartbeat } catch {} })
    $script:__CoGHeartbeatTimer.Start()
  }
} catch {
  try { Touch-Error } catch {}
}


## COGuardianTray.StatusJsonTelemetry
# Telemetry: write status.json locally so diagnostics never depend on HttpListener/URLACL/firewall.
# Location: %LOCALAPPDATA%\CoCivium\CoGuardian\status.json
try {
  if(-not (Get-Variable -Name CoGuardian_State -Scope Script -ErrorAction SilentlyContinue)){
    Set-Variable -Name CoGuardian_State -Scope Script -Value "OK"
  }
  if(-not (Get-Variable -Name CoGuardian_LastErrorUTC -Scope Script -ErrorAction SilentlyContinue)){
    Set-Variable -Name CoGuardian_LastErrorUTC -Scope Script -Value ""
  }

  function Write-CoGuardianStatusJson {
    param(
      [string]$State = $script:CoGuardian_State,
      [string]$LastErrorUTC = $script:CoGuardian_LastErrorUTC
    )
    try {
      $utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
      $dir = Join-Path $env:LOCALAPPDATA "CoCivium\CoGuardian"
      New-Item -ItemType Directory -Force -Path $dir | Out-Null
      $path = Join-Path $dir "status.json"
      $obj = [ordered]@{
        State = $State
        LastHeartbeatUTC = $utc
        LastErrorUTC = $LastErrorUTC
        Host = $env:COMPUTERNAME
        User = $env:USERNAME
        PID  = $PID
        TrayScript = "$PSCommandPath"
      }
      ($obj | ConvertTo-Json -Depth 3) | Set-Content -Encoding UTF8 -LiteralPath $path
    } catch {}
  }

  # Best-effort: call once immediately (then again from heartbeat if you add one later).
  Write-CoGuardianStatusJson
} catch {}


