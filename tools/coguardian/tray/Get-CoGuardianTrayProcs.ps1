param(
  [string]$RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

$Marker = "-CoGuardianTray"

$procs = Get-CimInstance Win32_Process | Where-Object { $_.Name -eq 'pwsh.exe' }

$byMarker = @($procs | Where-Object { $_.CommandLine -match [regex]::Escape($Marker) })
if($byMarker.Count -gt 0){
  $byMarker | Select-Object ProcessId, CommandLine
  return
}

# fallback (legacy procs)
$byName = @($procs | Where-Object { $_.CommandLine -match 'CoGuardianTray\.ps1' })
$byName | Select-Object ProcessId, CommandLine