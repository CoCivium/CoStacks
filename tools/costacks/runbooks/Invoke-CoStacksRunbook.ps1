param(

  [Parameter(Mandatory=$true,
  [Parameter(Mandatory=$false)][string]$Context
)
][string]$Name,
  [Parameter(Mandatory=$false)][switch]$Apply,
  [Parameter(Mandatory=$false)][switch]$Verify,
  [Parameter(Mandatory=$false)][string]$RepoRoot
)

Set-StrictMode -Version Latest

# COSTACKS_PATCH__ENGINE_SAFE_COPONG_WRITER__V1
. (Join-Path $PSScriptRoot 'Write-CoPong.ps1')
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Fail([string]$m){ throw "FAIL-CLOSED: $m" }
function Dot([string]$m){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ'), $m) }

if([string]::IsNullOrWhiteSpace($RepoRoot)){
  # default: repo root inferred from this file location: tools\costacks\runbooks\...
  $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
}

$runbookRel = ("tools\costacks\runbooks\runbook.{0}.ps1" -f $Name)
$runbook = Join-Path $RepoRoot $runbookRel

Dot ("Runbook={0} Apply={1} Verify={2}" -f $Name,$Apply.IsPresent,$Verify.IsPresent)
Dot ("RepoRoot={0}" -f $RepoRoot)

if(-not (Test-Path -LiteralPath $runbook)){
  Fail ("Runbook file not found: {0}" -f $runbookRel)
}

# Runbook contract:
# - file defines: Invoke-Runbook -RepoRoot <path> -Apply -Verify
. $runbook

if(-not (Get-Command Invoke-Runbook -ErrorAction SilentlyContinue)){
  Fail ("Runbook does not define Invoke-Runbook: {0}" -f $runbookRel)
}
$rbCmd = Get-Command Invoke-Runbook -ErrorAction Stop
if($rbCmd.Parameters.ContainsKey("Context")){
  Invoke-Runbook -RepoRoot $RepoRoot -Apply:$Apply.IsPresent -Verify:$Verify.IsPresent -Context $Context
} else {
  Invoke-Runbook -RepoRoot $RepoRoot -Apply:$Apply.IsPresent -Verify:$Verify.IsPresent
}
Dot "READY"


