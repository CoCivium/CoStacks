# Deprecation List v0.1
UTC_CREATED: 20260306T175252Z

Deprecate:
- chat-only inboxes with no receipts or external canon
- user-relayed payload dumps as primary transport
- unpinned latest links as durable canon
- mixing intake items with queue-ready work
- treating .live* as identity instead of recoverability alias
- success messaging before predicate verification
- interactive pasted megablocks without single execution wrapper
- service reachability used as proof of end-to-end usability

Replacement rule:
- prefer typed objects, pinned pointers, receipts, explicit lifecycle, and quarantine instead of silent loss

