# CoGuardian Tray Contract

Purpose: a lightweight SentinelUI. It must never require an interactive console.

Contract:
- Launch: pwsh -NoProfile -Sta -File <local or UNC> (STA mandatory).
- Detach: must not hold a visible console; Startup shortcut should be windowless.
- Log-first: write a log line before any UI init.
- Message loop: if using NotifyIcon (WinForms/WPF), it must maintain a durable message pump.
- Heartbeat: periodic 'alive' log entry.
- Degrade gracefully on UNC outage; prefer local cached copy if policy blocks UNC execution.

Design split recommendation:
- Headless sentinel runner (service/task) does monitoring.
- Tray only renders status and can restart headless runner.
