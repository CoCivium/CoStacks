# Handoff Gap Audit — 4.0|PRIME|260304 -> 4.0|PRIME|260307

## Purpose
This document is a devil's-advocate review of the current handoff state.
Its goal is to identify what a successor Prime may still fail to infer from repo alone.

## What exists now
- CoStacks architecture long-view document
- CoStacks inbox doctrine
- Prime handoff protocol
- CoStacks productization roadmap
- typed inbox / typed archive / receipts / logs / typed index
- DO block contract and transport rule work

## Major handoff risks still present
1. Git verification rail is still inadequate.
   - Some waves reported push-like progress while remote truth was not yet safely verified.
   - Success must bind to verified origin/main state, not local assumptions.

2. Dirty working tree protection is incomplete.
   - Local state such as docs/COHEALTH__LATEST.md interfered with pull behavior.
   - Future mutation waves should fail closed if working tree is not in an allowed state.

3. Operator transport/paste behavior is still under-specified.
   - Live blocks need header-only structure, no footer dependence, and trailing newline transport awareness.
   - Terminal rendering of marketing terminators may vary by codepage/font.

4. Typed inbox exists, but quarantine/dead-letter semantics are not yet first-class.
   - Repairable failures can still disappear into logs instead of lifecycle-managed objects.

5. Runner health telemetry is still weak.
   - The next Prime should not trust runner presence alone.
   - It should look for queue depth, worker count, error receipts, and latest receipt cadence.

6. Session drain discipline is improving but still relies too much on ad hoc human noticing.
   - The system should increasingly force drain artifacts before session termination.

## Required bootstrap test for successor Prime
The successor session should attempt two bootstraps:

### A. Repo-only bootstrap
Read only repo / typed / receipts / protocol docs.
Produce a written summary of inferred architecture, state, risks, and next priorities.

### B. Assisted bootstrap
Then read any SideNote / CoBus / pointer assist and compare.

### Required delta output
Write a delta report answering:
- What did repo-only bootstrap miss?
- What did SideNote assistance add?
- Which missing items should have been discoverable from repo but were not?
- Which protocols should be strengthened to reduce future dependence on chat-side assistance?

## Expected successor posture
- treat chat memory as non-canonical
- trust receipts over narrative
- trust typed state over prose
- distrust any claim not backed by repo artifacts
- improve rails where this session still relied on judgment instead of enforcement

## Recommended immediate next work for 4.0|PRIME|260307
1. verify and harden git truth rails
2. harden typed inbox lifecycle (quarantine/dead-letter/repair)
3. add runner health telemetry and status surfaces
4. formalize bootstrap delta test
5. decide how .live sessions and Workflows are adopted as subsessions through repo-first draining

## Final criticism
If the successor Prime still needs a narrative re-dump to understand current CoStacks state, then the handoff is not yet good enough.
