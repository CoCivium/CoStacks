# CoStacks Runbooks (Canonical)

This folder is a *headless* runbook engine for CoStacks automation.

## Rules (hard)
- **No interactive prompts** in runbooks (NO Read-Host).
- Engine **must** start with param() as first non-comment statement.
- Each runbook file: unbook.<name>.ps1 **must define** Invoke-Runbook.

## Engine
- Entry: Invoke-CoStacksRunbook.ps1
- Arguments:
  - -Name <runbookName>
  - -Apply <bool>
  - -Verify <bool>
  - -RepoRoot <path> (optional)
  - -Context <string> (optional; only passed if supported by the runbook)

## Violet receipts
Runbooks may emit violet receipts by calling the **function** Write-CoPong (made available by the engine).
Do **not** pipeline-invoke Write-CoPong.ps1 (that can cause binding prompts).

## Quick use
`powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File tools\costacks\runbooks\Invoke-CoStacksRunbook.ps1 -Name "ux.ps7" -Apply:True -Verify:True -Context "CoStacks.UX.PS7"
