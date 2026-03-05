Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

param(
  [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$Name,
  [switch]$Apply,
  [switch]$Verify,
  [Parameter(Mandatory=$false)][string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
)

function Dot([string]$m){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString("HH:mm:ssZ"), $m) }
function Fail([string]$m){ throw "FAIL-CLOSED: $m" }

$runbook = Join-Path $PSScriptRoot ("runbook.{0}.ps1" -f $Name)
if(-not (Test-Path -LiteralPath $runbook)){ Fail "Runbook not found: $runbook" }

Dot ("Runbook={0}" -f $Name)
Dot ("RepoRoot={0}" -f $RepoRoot)

$ctx = [pscustomobject]@{
  Name    = $Name
  Apply   = [bool]$Apply
  Verify  = [bool]$Verify
  RepoRoot= $RepoRoot
  Utc     = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
  TaskName= "CoCivium.CoGuardian.Watchdog"
}

. $runbook -Context $ctx

Dot "READY: no CoPong required unless VIOLET is printed by a runbook."
