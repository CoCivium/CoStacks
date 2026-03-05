<# CoStacks entrypoint (canonical)
Stable wrapper around runbook engine.
#>
param(
[Parameter(Mandatory=$true)][string]$Name,
[Parameter(Mandatory=$false)][bool]$Apply = $false,
[Parameter(Mandatory=$false)][bool]$Verify = $false,
[Parameter(Mandatory=$false)][string]$RepoRoot,
[Parameter(Mandatory=$false)][string]$Context
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Fail([string]$m){ throw "FAIL-CLOSED: $m" }

if([string]::IsNullOrWhiteSpace($RepoRoot)){

infer repo root from this file location: tools\costacks\Invoke-CoStacks.ps1

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "....")).Path
}

$engine = Join-Path $RepoRoot "tools\costacks\runbooks\Invoke-CoStacksRunbook.ps1"
if(-not (Test-Path -LiteralPath $engine)){ Fail "Missing engine: $engine" }

& "pwsh" -NoProfile -ExecutionPolicy Bypass -File $engine -Name $Name -Apply:$Apply -Verify:$Verify -RepoRoot $RepoRoot -Context $Context
