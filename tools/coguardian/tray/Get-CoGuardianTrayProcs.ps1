param(
  [string]$RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

if([string]::IsNullOrWhiteSpace($RepoRoot)){
  $RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).ProviderPath
}

$TrayCandidate = Join-Path $RepoRoot "tools\coguardian\tray\CoGuardianTray.ps1"
$TrayPath = [IO.Path]::GetFullPath($TrayCandidate)

function GetByExactPath(){
  $esc = [regex]::Escape($TrayPath)
  Get-CimInstance Win32_Process |
    Where-Object { $_.Name -eq 'pwsh.exe' -and $_.CommandLine -match $esc } |
    Select-Object ProcessId, CommandLine
}

function GetByFilenameFallback(){
  Get-CimInstance Win32_Process |
    Where-Object { $_.Name -eq 'pwsh.exe' -and $_.CommandLine -match 'CoGuardianTray\.ps1' } |
    Select-Object ProcessId, CommandLine
}

$exact = @(GetByExactPath)
if($exact.Count -gt 0){
  $exact
  return
}

# Fallback: still useful for smoke/stress; caller must enforce count==1
$fallback = @(GetByFilenameFallback)
$fallback