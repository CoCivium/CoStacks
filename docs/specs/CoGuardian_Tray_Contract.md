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
## Icon Status Telemetry (UI Contract) — 20260305T142820Z

Purpose: the tray icon must be diagnostically useful at a glance (and in screenshots).

Minimum UI signals (MUST):
- Presence: icon visible when running.
- State color: OK / WARN / FAIL.
- Activity: subtle animation or progress ring while work is happening.
- Comms: distinct transient overlay/state while uploading/syncing (CoBus/CoShare).
- Hover tooltip: includes SESSION_LABEL, ROLE, LastHeartbeatUTC, LastErrorUTC.

Recommended “ring” semantics:
- Outer ring = liveness heartbeat (ticks/rotates once per N seconds).
- Inner ring = active work progress (0–100%), resets to 0 when idle.
- Badge overlay = error count (e.g., small dot/number).

Diagnostics support:
- Screenshot of tray should be enough to infer: “running vs stalled vs failing vs syncing”.
