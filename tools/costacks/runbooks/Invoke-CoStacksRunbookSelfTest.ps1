<# CoStacks Runbook SelfTest (canonical)

Verifies engine + helper run without prompts

Runs ux.ps7 headless Apply/Verify
#>
param(
[Parameter(Mandatory=$false)][string]$RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Fail([string]$m){ throw "FAIL-CLOSED: $m" }
function Dot([string]$t){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ'), $t) }

if([string]::IsNullOrWhiteSpace($RepoRoot)){
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "......")).Path
}

$engine = Join-Path $RepoRoot "tools\costacks\runbooks\Invoke-CoStacksRunbook.ps1"
$helper = Join-Path $RepoRoot "tools\costacks\runbooks\Write-CoPong.ps1"
$ux = Join-Path $RepoRoot "tools\costacks\runbooks\runbook.ux.ps7.ps1"

foreach($p in @($engine,$helper,$ux)){
if(-not (Test-Path -LiteralPath $p)){ Fail "Missing: $p" }
}

Dot "SelfTest: helper via pwsh -File (must not prompt)"
$t1 = & "pwsh" -NoProfile -ExecutionPolicy Bypass -File $helper -From "X" -Utc "Y" -State "Z" -Intent "W" 2>&1
$t1s = ($t1 | Out-String)
if($t1s -match "Supply values"){ Fail "Helper prompted unexpectedly. Dump:`n$t1s" }

Dot "SelfTest: engine ux.ps7 Apply+Verify (must not prompt)"
$t2 = & "pwsh" -NoProfile -ExecutionPolicy Bypass -File $engine -Name "ux.ps7" -RepoRoot $RepoRoot -Apply:$true -Verify:$true -Context "CoStacks.SelfTest" 2>&1
$t2s = ($t2 | Out-String)
if($t2s -match "Supply values" -or $t2s -match "Context:"){ Fail "Engine/runbook prompted unexpectedly. Dump:`n$t2s" }

Dot "SelfTest: PASS"
