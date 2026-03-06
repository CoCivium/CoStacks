param(
  [Parameter(Mandatory=$true)][string]$Label,
  [Parameter(Mandatory=$false)][string]$Intent = "DO_WORK",
  [Parameter(Mandatory=$false)][string]$Success = "Return to prompt with no footer guidance.",
  [Parameter(Mandatory=$false)][bool]$ExpectViolet = $false,
  [Parameter(Mandatory=$false)][bool]$OperatorWaitOnly = $true,
  [Parameter(Mandatory=$false)][string]$Body = '$null | Out-Null'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$utc = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$vio = if($ExpectViolet){ 'YES' } else { 'NO' }
$wait = if($OperatorWaitOnly){ 'YES' } else { 'NO' }

$header = "<# DO [{0} {1}] | INTENT={2} | SUCCESS={3} | VIOLET={4} | WAIT_ONLY={5} #>" -f $Label,$utc,$Intent,$Success,$vio,$wait

$block = @(
  $header,
  '& {',
  'Set-StrictMode -Version Latest',
  '$ErrorActionPreference = "Stop"',
  $Body,
  '}',
  ''
) -join "`r`n"

$block