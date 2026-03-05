Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

$inst = Join-Path $PSScriptRoot "Install-CoGuardianWatchdogTask.ps1"
if(-not (Test-Path -LiteralPath $inst)){ throw "Missing installer: $inst" }

& $inst
