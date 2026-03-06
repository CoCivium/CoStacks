# Prime Session Handoff Protocol

## Purpose

Allow one Prime session to terminate without loss of momentum, CoCarry, or architectural direction.

## Canonical rule

The repo is the source of truth.
Chat is temporary.

## Handoff steps

1. Drain session intelligence into repo artifacts.
2. Ensure all meaningful CoCarry exists as durable files.
3. Emit or update receipts and typed index.
4. Record unresolved issues as typed notes or protocol docs.
5. Ensure next session can bootstrap by reading repo only.

## Minimum bootstrap for successor Prime

Read in this order:

1. docs/architecture/COSTACKS_ARCHITECTURE_LONG_VIEW.md
2. docs/architecture/COSTACKS_INBOX_DOCTRINE.md
3. docs/protocols/PRIME_SESSION_HANDOFF.md
4. docs/vision/COSTACKS_PRODUCTIZATION_ROADMAP.md
5. waves/typed/typed.index.json
6. docs/state/receipts/
7. waves/logs/

## Session identity guidance

Labels such as .liveYYYYMMDD.* are routing / recoverability labels, not identity proofs.

Canonical identity should remain stable.

## Mandatory carry surfaces

- architecture docs
- protocol docs
- typed notes
- receipts
- indices
- pinned pointers

## Rule for termination

A session should not be considered safely terminable until its important reasoning has been drained into repo artifacts.