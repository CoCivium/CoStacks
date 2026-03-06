# CoStacks High-Level Frame for CoPrime v0.1
UTC_CREATED: 20260306T201237Z

## Thesis
- CoStacks should be treated not as a script runner but as the execution and orchestration substrate for a civilizational-scale multi-being mindshare environment.

## Required architectural separations
1. intake / ideation inbox
2. promotion / routing
3. executable queue with claim/lease/retry/timeout
4. wave engine (one wave = one mutation = one reviewable output)
5. event / receipt layer
6. quarantine / dead-letter layer
7. pointer / bus discovery layer

## Typed object hints
- wave.job.json
- idea.note.json
- carry.note.json
- signal.event.json
- receipt.result.json

## Binding rules
- success output must bind to verified predicates
- chat memory is non-canonical
- canonical state lives in repos/vault/pinned pointers
- aliases like .liveYYYYMMDD.* are recoverability/routing labels, not identity proofs

## Why this matters
- Sessions are ephemeral workers; artifacts are durable system memory.

