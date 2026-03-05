<# New-CoStacksMegaZip (scaffold)
Creates a portable zip containing runbooks + manifests + receipts.
(Publishing to GitHub Releases / CoShare can be added later.)
#>
param(
[Parameter(Mandatory=$false)][string]$RepoRoot,
[Parameter(Mandatory=$false)][string]$OutDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Fail([string]$m){ throw "FAIL-CLOSED: $m" }
function Dot([string]$t){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ'), $t) }

if([string]::IsNullOrWhiteSpace($RepoRoot)){
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "......")).Path
}
if([string]::IsNullOrWhiteSpace($OutDir)){
$OutDir = (Join-Path $env:USERPROFILE "Downloads")
}
if(-not (Test-Path -LiteralPath $OutDir)){ New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }

$utc=(Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$zipName=("MEGAZIP__COSTACKS__RUNBOOKS__{0}.zip" -f $utc)
$zipPath=Join-Path $OutDir $zipName

$tmp = Join-Path $env:TEMP ("costacks_megazip_" + $utc)
if(Test-Path -LiteralPath $tmp){ Remove-Item -Recurse -Force -LiteralPath $tmp }
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

Include runbooks + manifest + receipts

$items = @(
"tools\costacks\runbooks",
"docs\state\receipts"
)
foreach($rel in $items){
$src = Join-Path $RepoRoot $rel
if(Test-Path -LiteralPath $src){
$dst = Join-Path $tmp $rel
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
Copy-Item -Recurse -Force -LiteralPath $src -Destination $dst
}
}

Compress-Archive -Path (Join-Path $tmp "*") -DestinationPath $zipPath -Force
$sha = (Get-FileHash -Algorithm SHA256 -LiteralPath $zipPath).Hash
$shaPath = ($zipPath + ".sha256.txt")
@(
"FILE=" + $zipName
"SHA256=" + $sha
"UTC=" + $utc
) | Set-Content -Encoding UTF8 -LiteralPath $shaPath

Dot ("MEGAZIP=" + $zipPath)
Dot ("SHA256=" + $sha)
