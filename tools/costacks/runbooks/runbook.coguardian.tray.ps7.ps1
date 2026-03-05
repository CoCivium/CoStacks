<# runbook.coguardian.tray.ps7 (canonical, headless)
   Apply: start tray bootstrap (hidden by default)
   Verify: confirm tray process exists
#>
function Invoke-Runbook {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$false)][bool]$Apply = $false,
    [Parameter(Mandatory=$false)][bool]$Verify = $false
  )

  Set-StrictMode -Version Latest
  $ErrorActionPreference='Stop'
  $ProgressPreference='SilentlyContinue'

  function Dot([string]$m){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ'), $m) }

  $boot = Join-Path $RepoRoot "tools\coguardian\tray\CoGuardianTray_Bootstrap.ps1"
  if($Apply){
    Dot "Apply: launching tray bootstrap"
    & "pwsh" -NoProfile -ExecutionPolicy Bypass -File $boot | Out-Null
  }

  if($Verify){
    Dot "Verify: looking for tray process (pwsh hosting CoGuardianTray.ps1)"
    $p = Get-CimInstance Win32_Process |
      Where-Object { $_.Name -match 'pwsh\.exe' -and $_.CommandLine -match 'CoGuardianTray\.ps1' } |
      Select-Object -First 5 ProcessId,CommandLine
    if($p){
      $p | Format-List | Out-String | Write-Host
    } else {
      Dot "Verify: NOT FOUND"
    }
  }

  try {
    if(Get-Command Write-CoPong -ErrorAction SilentlyContinue){
      $utc=(Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
      Write-CoPong -From "CoStacks" -Utc $utc -State "done" -Intent "COGUARDIAN_TRAY_RUNBOOK_APPLY_VERIFY" -Note "Apply launches tray bootstrap; Verify checks pwsh cmdline for CoGuardianTray.ps1"
    }
  } catch {}
}
