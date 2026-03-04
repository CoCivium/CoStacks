# COGUARDIAN MVP Visible Surface (Wave1)

## Browser icon (Edge / Chrome)
Load unpacked from:
- \	ools/coguardian/extension_mv3\

Steps:
1. \dge://extensions\ or \chrome://extensions\
2. Enable Developer mode
3. Load unpacked -> select the folder above
4. Pin the CoGuardian icon in the browser toolbar

## System tray icon (reversible)
Run:
- \pwsh -NoProfile -ExecutionPolicy Bypass -File tools/coguardian/tray/CoGuardianTray.ps1\

Right-click tray icon for actions.
Close/Exit = nothing persists.

## Next (Wave2)
Wire popup + tray to local CoHealth status + receipts, then (optional) startup task (reversible).