# CoGuardianTray.ps1 - minimal visible system-tray surface for CoStacks (MVP)
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

$mi3 = New-Object System.Windows.Forms.ToolStripMenuItem 'Run CoGuardian scan.ps1 (local)'
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
