<# Write-CoPong (canonical)
   - Exposes function: Write-CoPong (safe, no interpolation)
   - Also supports running as a script file via -File ...Write-CoPong.ps1 -From ... -Utc ...
#>

function Write-CoPong {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)][string]$From,
    [Parameter(Mandatory=$true)][string]$Utc,
    [Parameter(Mandatory=$true)][string]$State,
    [Parameter(Mandatory=$true)][string]$Intent,
    [Parameter(Mandatory=$false)][string]$Sha,
    [Parameter(Mandatory=$false)][string]$BaseSha,
    [Parameter(Mandatory=$false)][string]$Note,
    [Parameter(Mandatory=$false)][string]$To = 'ALL_ACTIVE_SESSIONS'
  )

  Set-StrictMode -Version Latest
  $ErrorActionPreference='Stop'

  # Build WITHOUT string interpolation so any $ chars remain literal
  $parts = New-Object System.Collections.Generic.List[string]
  $parts.Add('<# CoPong | TO=' + $To)
  $parts.Add('FROM=' + $From)
  $parts.Add('UTC=' + $Utc)
  $parts.Add('STATE=' + $State)
  $parts.Add('INTENT=' + $Intent)
  if($Sha){ $parts.Add('SHA=' + $Sha) }
  if($BaseSha){ $parts.Add('BASESHA=' + $BaseSha) }
  if($Note){ $parts.Add('NOTE=' + $Note) }
  $parts.Add('#>')

  $line = '###VIOLET_COPONG### ' + ($parts -join ' | ')
  Write-Host ("`e[95m{0}`e[0m" -f $line)
}

# If invoked as a script file, bind parameters and call the function.
# NOTE: param() must be first non-comment STATEMENT, but functions above are fine.
# We detect file invocation via $MyInvocation.InvocationName / $PSCommandPath.
if($PSCommandPath -and ($MyInvocation.PSCommandPath -eq $PSCommandPath)){
  param(
    [Parameter(Mandatory=$true)][string]$From,
    [Parameter(Mandatory=$true)][string]$Utc,
    [Parameter(Mandatory=$true)][string]$State,
    [Parameter(Mandatory=$true)][string]$Intent,
    [Parameter(Mandatory=$false)][string]$Sha,
    [Parameter(Mandatory=$false)][string]$BaseSha,
    [Parameter(Mandatory=$false)][string]$Note,
    [Parameter(Mandatory=$false)][string]$To = 'ALL_ACTIVE_SESSIONS'
  )
  Write-CoPong -From $From -Utc $Utc -State $State -Intent $Intent -Sha $Sha -BaseSha $BaseSha -Note $Note -To $To
}
