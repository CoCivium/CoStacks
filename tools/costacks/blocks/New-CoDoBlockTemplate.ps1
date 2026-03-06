param([string]$Label)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$utc = (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
$header = "<# DO [{0} {1}] | ENDS_AT_PROMPT=YES #>" -f $Label,$utc
$block = @(
  $header
  '& {'
  'Set-StrictMode -Version Latest'
  '$ErrorActionPreference = "Stop"'
  '"template ok" | Out-Host'
  '}      # ⊂'
  ''
  ''
) -join "`r`n"
$block
