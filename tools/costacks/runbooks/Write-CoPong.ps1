Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'

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

# Build without string interpolation so any $ chars are literal.
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
