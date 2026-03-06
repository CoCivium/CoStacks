# Queue and Wave Engine Design Guidance v0.1
UTC_CREATED: 20260306T175252Z

## Decision table

| Concern | Guidance |
|---|---|
| routing | route by object_type + lane + status |
| retry | retry only executable queue items, never raw ideas/signals |
| quarantine | malformed / unsafe / ambiguous objects go to quarantine with reason |
| receipts | emit receipt.result.json at claim/start/finish/fail milestones |
| waves | one wave should emit one reviewable output |
| failures | failed waves should still emit minimal failure receipts |
| success | success text must bind to verified predicates |

## Retry policy
- wave.job.json: bounded retry with attempt_count and last_error
- idea.note.json: no retry; review or archive
- carry.note.json: no retry; drain/review/archive
- signal.event.json: append-only; no retry semantics
- receipt.result.json: immutable evidence; never retried

## Quarantine policy
- missing required fields -> quarantined
- invalid object_type -> quarantined
- ambiguous lane / routing target -> quarantined
- stale or superseded executable item -> quarantined or archived

## Migration path from legacy patterns
- CoBus notes -> map to signal.event.json or carry.note.json depending on payload
- CoCarry drops -> map to carry.note.json
- ad hoc pending work files -> map to idea.note.json first, then promote to wave.job.json
- session drain / handoff text -> carry.note.json + receipt.result.json pointer pack

## Naming rules
- object filenames should include type first, then timestamp or stable id
- keep status in metadata, not filename
- keep aliases separate from canonical IDs

