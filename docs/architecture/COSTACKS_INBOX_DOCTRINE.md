# CoStacks Inbox Doctrine

## Principle

Inbox is not merely a script queue.

Inbox is a typed coordination plane.

## Why

If inbox only holds executable scripts, then ideation, carry, signals, failures, and handoff state are forced back into chat or human memory.

That is brittle.

## Required separation

CoStacks must keep ideation distinct from execution.

At minimum:

- idea.note = non-executable ideation / optionality
- carry.note = payload waiting for later routing / drain / integration
- signal.event = observations, state changes, health events
- wave.job = executable work
- receipt.result = outcome record

## Lifecycle

1. intake
2. type assignment
3. route
4. execute or archive
5. emit receipt
6. index for future sessions

## Rules

- all inbox items should be typed
- execution should be receipted
- failed routing should be quarantined, not lost
- every session should drain valuable chat intelligence into typed artifacts before termination
- typed index must remain readable by future Prime sessions

## Implication

Inbox is the bridge between ephemeral session thinking and durable orchestration state.