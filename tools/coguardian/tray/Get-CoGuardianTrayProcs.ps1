param(
  [string]$RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

if([string]::IsNullOrWhiteSpace($RepoRoot)){
  # If called from anywhere, infer repo root relative to this script: tools\coguardian\tray -> repo root
  $RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).ProviderPath
}

$TrayCandidate = Join-Path $RepoRoot "tools\coguardian\tray\CoGuardianTray.ps1"
$TrayPath = (Resolve-Path -LiteralPath $TrayCandidate).ProviderPath
$esc = [regex]::Escape($TrayPath)

Get-CimInstance Win32_Process |
  Where-Object { $_.Name -eq 'pwsh.exe' -and $_.CommandLine -match $esc } |
  Select-Object ProcessId, CommandLine