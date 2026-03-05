# PrimeBootstrapProtocol

Deterministic ritual for any Prime wave:

1. Fetch CoBeacon RAW (commit-pinned). Follow FULL-URL pointers only.
2. Open DISPATCH__LATEST (commit-pinned). Apply directives for your SESSION_LABEL/ROLE.
3. Verify repo state anchors/packets exist (docs/state/...).
4. Execute only fail-closed DO blocks; emit receipts to docs/state/receipts/.
5. Broadcast pointer-only updates via CoBusMirror (commit-pinned).

Non-canon: chat/session memory. Canon: repo pins + SHAs + receipts.
