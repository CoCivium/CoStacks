# CoStacks Architecture — Long View

## Core framing

CoStacks should be treated not as a script runner but as the execution and orchestration substrate for a civilization-scale multi-being mindshare environment.

Its role is to turn artifacts, pointers, intents, receipts, and typed objects into reliable workflows across many sessions, repos, agents, and eventually many classes of intelligence.

Chat memory is non-canonical.
Canonical state lives in repos, vault surfaces, pinned pointers, logs, receipts, and typed stores.

## Current implemented kernel

Today CoStacks already contains the minimum viable orchestration kernel:

- wave inbox
- WaveRunner
- Dispatcher
- typed archive
- receipts
- logs
- typed index

Current execution path:

inbox -> WaveRunner -> Dispatcher -> typed archive / receipts / logs / index

## Architectural layers

### 1. Intake / ideation layer

Purpose:
capture optionality before execution.

Objects:
- idea.note
- carry.note
- signal.event

This layer exists so ideation does not get mixed up with execution.

### 2. Promotion / routing layer

Purpose:
classify inbox objects, assign type, decide whether they become executable work, persistent notes, signals, or quarantine items.

This is the transition layer between thought and action.

### 3. Executable queue

Purpose:
manage runnable work with future support for claim, lease, timeout, retry, backoff, and priority.

Current primitive:
wave.job / .ps1 execution through WaveRunner.

Future primitive:
typed executable queue with one-wave-one-mutation discipline.

### 4. Wave engine

Purpose:
execute exactly one bounded mutation and produce one reviewable output.

Rule:
one wave = one mutation = one reviewable output.

This is the core anti-bloat execution discipline.

### 5. Event / receipt layer

Purpose:
record facts, verification results, outcomes, and status transitions.

Objects:
- receipt.result
- signal.event

Success must bind only to verified predicates.

### 6. Quarantine / dead-letter layer

Purpose:
retain repairable failures instead of silently losing them.

Future objects:
- quarantine.note
- error.receipt
- repair.task

### 7. Pointer / bus layer

Purpose:
thin discovery, coordination, and handoff using pinned paths, artifacts, manifests, and receipts instead of chat retelling.

This layer is how CoStacks stays repo-first and session-light.

## Typed objects

Current baseline object types:

- wave.job
- idea.note
- carry.note
- signal.event
- receipt.result

Future useful object types:

- research.task
- runner.health
- repo.mutation
- handoff.bundle
- policy.decision
- repair.task
- deadletter.item

## Design rules

- Canonical state lives in repo / vault / pinned artifacts, not chat.
- Sessions are ephemeral workers, not memory stores.
- Failed waves must still emit minimal failure receipts.
- Success messages bind only to verified predicates.
- Presence of a repo, process, port, or file is not proof of end-to-end success.
- Ideation must remain distinct from execution.
- Handoffs must be first-class.
- Receipts, indices, and pointer bundles are mandatory, not optional.

## Long-horizon vision

In the long run, CoStacks becomes a hybrid civilization operating substrate.

It orchestrates humans, AIs, and other presented intelligences through shared artifacts, protocols, typed intents, receipts, and pointer surfaces.

The future system is not chat-centric.
It is artifact-centric, receipt-centric, and coordination-centric.

That makes CoStacks a candidate substrate for communal mindshare environments, multi-agent governance, and civilization-scale workflow orchestration.