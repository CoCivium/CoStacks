param([Parameter(Mandatory=$true)]$Context)

Set-StrictMode -Version Latest

# COSTACKS_PATCH__UX_RUNBOOK_CONTEXT_DEFAULT__V2
if([string]::IsNullOrWhiteSpace($Context)){
  $Context = $env:COSTACKS_CONTEXT
  if([string]::IsNullOrWhiteSpace($Context)){ $Context = 'CoStacks.UX.PS7' }
}
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

function Dot([string]$m){ Write-Host ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString("HH:mm:ssZ"), $m) }
function Fail([string]$m){ throw "FAIL-CLOSED: $m" }

Dot "Runbook: ux.ps7 (safe, opt-in)"

if(-not $Context.Apply){
  Dot "Apply not set; nothing to do."
  return
}

# Safe UX: set prompt function via CurrentUser profile only; no registry hacks.
$prof = $PROFILE.CurrentUserAllHosts
$dir = Split-Path -Parent $prof
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$marker = "# COGUARDIAN_PATCH__UX_PS7_PROMPT__V1"
$existing = ""
if(Test-Path -LiteralPath $prof){ $existing = Get-Content -LiteralPath $prof -Raw -Encoding UTF8 }

if($existing -match [regex]::Escape($marker)){
  Dot "Profile already patched: $prof"
  return
}

$patch = @"
$marker
function global:prompt {
  try {
    \$utc = (Get-Date).ToUniversalTime().ToString('HH:mm:ssZ')
    \$p = (Get-Location).Path
    # Yellow prompt + explicit PS7 marker
    Write-Host ("[`$utc] [PS7] " ) -NoNewline -ForegroundColor Yellow
    Write-Host (\$p) -NoNewline -ForegroundColor Yellow
    return "`n> "
  } catch {
    return "PS7> "
  }
}
"@

Set-Content -LiteralPath $prof -Encoding UTF8 -Value ($existing + "`r`n" + $patch + "`r`n")
Dot "Patched PS7 prompt in: $prof"
Dot "NOTE: cursor shape is terminal-controlled (Windows Terminal). We can ship a WT fragment next if you want."

