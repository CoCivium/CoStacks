# Ideation Inbox Schema v0.1
UTC_CREATED: 20260306T175252Z

Goal: small canonical metadata schema for typed inbox objects.

## Required common fields
- object_type
- object_id
- utc_created
- source_session
- source_role
- title
- summary
- lane
- priority
- status
- input_ptrs
- receipt_ptrs
- owner (optional)
- supersedes (optional)
- expires_utc (optional)

## Canonical object types
- wave.job.json        => executable work item
- idea.note.json       => non-executable ideation
- carry.note.json      => handoff / retained session payload
- signal.event.json    => state signal / event / transition
- receipt.result.json  => proof of execution / validation outcome

## Status lifecycle
- captured
- reviewed
- promotable
- queued
- claimed
- running
- succeeded
- failed
- quarantined
- rejected
- archived

## Routing rules
- idea.note.json stays non-executable until promoted
- carry.note.json routes to review / drain / archive
- wave.job.json must have lane + owner/claim semantics before execution
- signal.event.json never becomes executable directly
- receipt.result.json is append-only evidence

