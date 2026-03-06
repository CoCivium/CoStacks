# Pattern Catalog v0.1
UTC_CREATED: 20260306T175252Z

Purpose: consumable inbox / queue / bus patterns for CoStacks.

## Canonical patterns
- Intent Inbox: append-only intake for non-executable ideas / concerns / candidates.
- Executable Queue: queue of claimable work items with lease/retry/dead-letter.
- Event Log: facts, receipts, transitions, signals; not a task list.
- Wave Ledger: one wave = one mutation = one output; tracks DONE / DOING / BLOCKED / NEXT.
- Reject / Quarantine Store: malformed or unsafe items held for repair, not silently dropped.
- Pointer Bundle: summary + pointers only for upstream review.

## Recommended separation
- inbox = intake
- queue = executable
- event log = facts / receipts
- ledger = orchestration memory
- quarantine = rejects / repair

## Canonical item types
- wave.job.json
- idea.note.json
- carry.note.json
- signal.event.json
- receipt.result.json

