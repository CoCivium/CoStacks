<# CoStacks Runbook Engine (canonical)
   Rules:
   - param() MUST be first non-comment statement
   - runbook file must define: Invoke-Runbook
#>
param(
  [Parameter(Mandatory=$true)][string]$Name,
  [Parameter(Mandatory=$false)][switch]$Apply,
  [Parameter(Mandatory=$false)][switch]$Verify,
  [Parameter(Mandatory=$false)][string]$RepoRoot,
  [Parameter(Mandatory=$false)][string]$Context
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Fail([string]$m){ throw "FAIL-CLOSED: $m" }
function Dot([string]$m){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ'), $m) }

if([string]::IsNullOrWhiteSpace($RepoRoot)){
  $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
}

. (Join-Path $PSScriptRoot "Write-CoPong.ps1")  # available if runbook wants it

$runbookRel = ("tools\costacks\runbooks\runbook.{0}.ps1" -f $Name)
$runbook = Join-Path $RepoRoot $runbookRel

Dot ("Runbook={0} Apply={1} Verify={2}" -f $Name,$Apply.IsPresent,$Verify.IsPresent)
Dot ("RepoRoot={0}" -f $RepoRoot)

if(-not (Test-Path -LiteralPath $runbook)){
  Fail ("Runbook file not found: {0}" -f $runbookRel)
}

. $runbook

$rbCmd = Get-Command Invoke-Runbook -ErrorAction SilentlyContinue
if(-not $rbCmd){
  Fail ("Runbook does not define Invoke-Runbook: {0}" -f $runbookRel)
}

if($rbCmd.Parameters.ContainsKey("Context")){
  Invoke-Runbook -RepoRoot $RepoRoot -Apply:$Apply.IsPresent -Verify:$Verify.IsPresent -Context $Context
} else {
  Invoke-Runbook -RepoRoot $RepoRoot -Apply:$Apply.IsPresent -Verify:$Verify.IsPresent
}

Dot "READY"
