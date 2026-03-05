<# runbook.ux.ps7 (canonical, headless)
   Goal: make pwsh/CLI UX feel CoCivium (prompt, cursor, title), WITHOUT ever prompting for input.
#>

function Invoke-Runbook {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$false)][bool]$Apply = $false,
    [Parameter(Mandatory=$false)][bool]$Verify = $false,
    [Parameter(Mandatory=$false)][string]$Context
  )

  Set-StrictMode -Version Latest
  $ErrorActionPreference='Stop'
  $ProgressPreference='SilentlyContinue'

  if([string]::IsNullOrWhiteSpace($Context)){
    $Context = $env:COSTACKS_CONTEXT
    if([string]::IsNullOrWhiteSpace($Context)){ $Context = "CoStacks.UX.PS7" }
  }

  Write-Host ("[{0}] Runbook: ux.ps7 (headless) Context={1} Apply={2} Verify={3}" -f (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ'), $Context, $Apply, $Verify)

  # Apply: minimal, reversible UX signals (NO prompts)
  if($Apply){
    # Title hint (works in most terminals)
    try { $host.UI.RawUI.WindowTitle = ("PS7 | {0}" -f $Context) } catch {}

    # Prompt function hint (only affects current session unless user chooses to persist)
    # We avoid auto-persisting to profile in this runbook.
    try {
      function global:prompt {
        $p = (Get-Location).Path
        return ("`e[93mPS7`e[0m `e[90m{0}`e[0m> " -f $p)
      }
    } catch {}
  }

  # Verify: print a short status line (still headless)
  if($Verify){
    try {
      $pv = $PSVersionTable.PSVersion.ToString()
      Write-Host ("Verify: PSVersion={0} Host={1}" -f $pv, $Host.Name)
    } catch {}
  }

  # If available, emit a violet receipt using the FUNCTION (not the .ps1 file name)
  try {
    if(Get-Command Write-CoPong -ErrorAction SilentlyContinue){
      $utc=(Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
      Write-CoPong -From "CoStacks" -Utc $utc -State "done" -Intent "UX_PS7_RUNBOOK_APPLIED_OR_VERIFIED" -Note ("Context=" + $Context)
    }
  } catch {}
}
