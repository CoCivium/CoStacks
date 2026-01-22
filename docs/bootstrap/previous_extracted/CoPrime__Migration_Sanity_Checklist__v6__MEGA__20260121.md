# CoPrime Migration Sanity Checklist — MEGA (v6)
**Version:** v6 (MEGA)  
**Date:** 20260121 (UTC build 20260121T204953Z)  
**Primary deliverable pair:** this document + receipt (SHA256)  
**Goal:** Single self-contained checklist/reference that includes everything discussed in this thread (including the Top-50 list) and adds a small set of additional ops best practices to reduce drift/leaks.

---

## 0) Non-negotiables (canon discipline)
1. One canonical home per asset. Everything else is mirror/cache/snapshot.
2. No copy/paste canon across homes. Use pointers + registry.
3. Every release ships a receipt (hashes) and a changelog entry.
4. LATEST files are pointers (not duplicated content).
5. If two things look similar but differ, treat it as a fork until proven otherwise.

---

## 1) Canonical Homes Policy (GitHub ↔ CoShare ↔ CoSources)
### Seed defaults
- GitHub: collaboration surface + public snapshots only
- CoShare: private canonical vault (crown jewels, legal/patent, internal ops)
- CoSources: evidence layer (standards, citations, rationale, “why we believe this”)

### Mirror rules (must be explicit)
- Mirrors must be declared in PointerRegistry.
- Mirrors never become canonical without explicit promotion.
- Public snapshots require a redaction pass and signoff.

---

## 2) QuickStart (2 hours)
1) Create CanonicalPaths.yml (automation entrypoint; hard-fail if missing).
2) Create PointerRegistry.jsonl (append-only registry of canon + mirrors + hashes).
3) Adopt Wave DoD (see §6) and enforce it.
4) Sweep worst 10 repos/folders using the rubric (see §7).
5) Label crown-jewel areas (see §5).

Stop until these are in place and stable.

---

## 3) CanonicalPaths.yml
Required keys (minimum):
- CanonicalPathsVersion
- MasterPlanLatest
- PointerRegistry
- CoShareRoot
- CoSourcesRoot
- InboxRoot
- ArchiveRoot
- PublicSnapshotsRoot

Change discipline:
- Any edit requires a dated changelog entry.
- Any edit triggers a drift scan.

---

## 4) PointerRegistry.jsonl
Required fields:
- asset_id, title, canonical_uri, mirrors[], version, sha256, owner, access_class, last_verified_utc

Hard-fail conditions:
- same asset_id with different canonical_uri
- same asset_id + same version with different sha256
- missing CROWN_JEWEL targets (and missing receipts)

---

## 5) Data classification + access control
Classes:
- PUBLIC / INTERNAL / CONFIDENTIAL / CROWN_JEWEL

Minimum controls:
- CoShare RBAC + break-glass
- Public snapshot export = redaction checklist + signoff
- secrets never in repos; define storage + rotation cadence

---

## 6) Migration Wave Definition of Done
A wave is not done until:
1. canonical homes declared
2. CanonicalPaths updated (if needed) + dated changelog
3. PointerRegistry updated + hashes recorded
4. old locations frozen or pointer-stubbed
5. receipts generated for crown-jewel touches
6. drift scan PASS (or manual drift review PASS)
7. handoff note emitted (template below)

Handoff note template:
```text
# SideNote from <session> to CoPrime:
Wave: <name>  UTC=<timestamp>
CanonPaths: <path>
PointerRegistry: <path>
New/Updated assets:
- <asset_id> v<ver> sha256=<hash> canonical=<uri>
Drift scan: PASS|FAIL  (report=<path>)
Repo hygiene sweep: PASS|WARN  (worst gaps=<list>)
Next recommended actions (top 3):
1) ...
2) ...
3) ...
```

---

## 7) Repo + Folder “Inspiration & Clarity” Rubric (0–5 each)
- Clarity
- Actionability
- Canon visibility
- Contributor comfort
- Trust posture
- Narrative

Thresholds:
- Seed minimum avg ≥ 3.5 and no category < 2
- Public-facing avg ≥ 4.0

Baseline repo files:
- README, CONTRIBUTING, CODE_OF_CONDUCT, LICENSE, SECURITY

Baseline folder file:
- _INDEX.md (required)

---

## 8) CoMetaTrain + CoCTA standard
Recommended front-matter:
```yaml
co_stage: seed|soft_launch|later
co_cta_primary: "Open an issue with your use-case"
co_cta_secondary: "Pick a starter task"
co_metatrain_tags: ["xr","reputation","privacy","integrity","automation"]
co_owner: "CoPrime"
co_last_reviewed: "20260121"
```
Rules:
- Max 2 CTAs above the fold.
- Every key doc links: evidence → action → canonical pointer.

---

## 9) Evidence layer (CoSources) — format
```
CLAIM: ...
EVIDENCE: <url or doc pointer>
ASSUMPTION: ...
RISK: ...
SUPERSEDED-BY: <pointer>
LAST-CHECKED: YYYY-MM-DD
```

---

## 10) Health metrics (prevent decay)
Weekly:
- drift findings count
- missing baseline repo files count
- % top docs reviewed within 30 days
- stale evidence older than policy
- median time-to-first-contribution
- crown-jewel items missing receipts

Rule: if worse 2 cycles, pause new work and pay down ops debt.

---

## 11) Prioritized Top-50 additions (full list)
1. Define & publish Canonical Homes Policy (GitHub vs CoShare vs CoSources) + enforcement language.
2. Ship a Pointer Registry schema (AssetID, CanonicalURI, Mirrors, Version, SHA256, Owner, LastVerifiedUTC, AccessClass).
3. Create a Canonical Paths / LATEST Pointers single file and treat it as the entrypoint for all automation.
4. Adopt a No-Shadow-Forks rule: deprecated homes become pointer-only + read-only + name reservation.
5. Add a Data Classification scheme (PUBLIC / INTERNAL / CONFIDENTIAL / CROWN-JEWEL) + handling rules.
6. Implement Hash Receipt Standard (file-level + package-level) + verification snippets (PS/macOS/Linux).
7. Add a Versioning policy (SemVer-ish for docs/assets) + what constitutes major/minor/patch.
8. Add Changelog discipline: every canonical doc has dated deltas + rationale + supersession pointers.
9. Define Access Control model for CoShare (roles, approvals, break-glass) + auditability expectations.
10. Create a RACI for migration + ongoing ops (owners for repos, docs, standards radar, automation).
11. Create a Migration Cutover Playbook (dry-run, freeze window, validation, rollback).
12. Add Fork/Drift Detection script spec (detect duplicate LATEST, mismatched hashes, duplicate names).
13. Define Mirror Rules (what mirrors to GitHub, what never does; how often; what format).
14. Add Repo Description/README QA rubric (scored checklist for inspiration + clarity).
15. Create Contributor Funnel spec: 30-minute onboarding path + starter issues + credits policy.
16. Add Issue/PR templates for each repo (bug, feature, doc, standards update) with required fields.
17. Add Governance gates: what requires review vs can be auto-merged; emergency fast path.
18. Adopt Docs Architecture standard (Diátaxis mapping + mandatory nav/index patterns).
19. Create CoSources Evidence Ledger format (CLAIM/EVIDENCE/ASSUMPTION/RISK/SUPERSEDED-BY).
20. Add a Standards Radar page spec (Adopt / Trial / Watch / Reject with dates + why).
21. Add a Recency policy: sources older than X get flagged; define X by domain.
22. Create Link Integrity checks (pointer links + references) as a routine/CI step.
23. Define Naming Conventions for files/folders (dates, versions, LATEST pointers, prefixes).
24. Define Metadata fields for folders (purpose, scope, owner, access class, retention).
25. Add Retention + Archiving policy (what gets archived, when; immutable archive rules).
26. Add Backup + Restore playbook for CoShare (RPO/RTO targets, test restores).
27. Add Incident Response mini-runbook (security leak, corrupted canon, bad release).
28. Add Secrets Handling rules (no secrets in repos; where secrets live; rotation cadence).
29. Add Release Train pattern (alpha/beta/seed) + what artifacts are produced each release.
30. Adopt SBOM baseline plan (format choice + generation step at releases).
31. Adopt Dependency security minimum (automated alerts + update cadence).
32. Adopt Supply chain integrity roadmap (commit signing, provenance/attestations) as later phase.
33. Add Repo Health dashboard spec (open issues, stale PRs, link failures, missing files).
34. Add Docs Lint spec (style, headings, broken links, front-matter presence).
35. Define Single Entry Points for automation (scripts/Makefile/PS modules) + docs.
36. Add Deterministic Packaging requirements (stable zip structure; normalized timestamps if needed).
37. Add Artifact Manifest standard (MANIFEST.json listing files, versions, hashes).
38. Add Cross-repo dependency map doc (what depends on what; update triggers).
39. Define Environment separation rules (dev/test/prod equivalents; what data can be used).
40. Define Observability for automation (logs, success/fail counters, notifications).
41. Add Merge discipline (branch naming, squash vs rebase, required checks).
42. Add License/Attribution policy for third-party sources in CoSources (avoid copy/paste; summarize).
43. Add Brand/Voice guide for repo descriptions + CoCTA tone consistency (seed appropriate).
44. Add Public Snapshot policy: what can be published; redaction rules; review step.
45. Add Partner/vendor intake checklist (NDA state, data sharing rules, storage location).
46. Add Change request process for standards/best practices (proposal → review → adopt).
47. Add Decommission protocol (how to retire repos/paths without breaking pointers).
48. Add Definition of Done for migration wave (validation steps + receipts + CoPrime note).
49. Add Quarterly audit ritual for Master Plan alignment (scope, evidence, risk, drift).
50. Add Docs-ops cadence: recurring staleness sweep for pointers, LATEST files, and citations.

---

## 12) Additional improvements worth adding
- Add a Citation Capture Standard: every non-trivial claim in CoSources stores (a) source URL, (b) access date, (c) quote excerpt ≤25 words, (d) your paraphrase, (e) confidence, (f) counter-source if contested.
- Add a Threat Model Lite for CoShare/CoSources: top 10 leak vectors + mitigations + owner per mitigation.
- Add a Redaction Playbook for public snapshots (patterns to redact + review gates).
- Add a Schema Registry for all JSON/YAML formats used (CanonicalPaths, PointerRegistry, Manifests, Evidence Ledgers) with schema versioning.
- Add a Golden Path onboarding pack: one page for contributors, one for maintainers, one for stewards; each with 5 actions + 3 anti-patterns.
- Add a Docs-as-Product owner + cadence (monthly review) for README/Docs in seed phase.
- Add a Source-of-Truth banner template for every repo/folder.
- Add a Change Freeze Protocol for cutovers (freeze labels, timing, thaw procedure).
- Add a Quality Budget policy (max allowed drift findings / stale evidence / missing rubric items).
- Add an Audit Trail Minimum for crown-jewel changes (who/when/why recorded in receipt/changelog).

---

## 13) Bundle contents
This MEGA bundle includes:
- v6 MEGA doc + receipt + manifest
- prior version zips found locally (v1–v5) under /previous/
- v5 tooling bundle preserved under /tools/ (if v5 zip was available)

---

## 14) Diminishing returns checkpoint
From here, improvements should be measured + automated:
- run drift checks against real trees and store reports
- tighten rules based on failures observed
- wire into CI/scheduled tasks
- build Standards Radar + citation capture pipeline in CoSources

---

## Changelog
- v6 (MEGA) — Consolidated all thread content into one doc, retained Top-50 list verbatim, added extra ops items, and bundled prior zips + tooling.
