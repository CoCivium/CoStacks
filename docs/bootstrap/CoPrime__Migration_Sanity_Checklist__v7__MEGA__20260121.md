# CoPrime Migration Sanity Checklist — MEGA (v7)
**Version:** v7 (MEGA)  
**Date:** 20260121 (UTC build 20260121T210125Z)  
**Primary deliverable pair:** this document + receipt (SHA256)  
**Intent:** Superset package: includes everything discussed (incl. Top-50) + bundles tools/templates/schemas + embeds full prior doc text (v2–v6) to prevent omissions.

---

## 0) Critical path (do this first)
1) Create `CanonicalPaths.yml` (single entrypoint; automation hard-fails if missing).  
2) Create `PointerRegistry.jsonl` (append-only; all canon has an AssetID + SHA).  
3) Enforce the Wave Definition of Done (receipts + drift check + handoff note).  
4) Adopt evidence discipline in CoSources (Citation Capture template; LAST-CHECKED).  
5) Stop-the-line on drift: if forks/staleness rise, pause new work until resolved.

---

## 1) Non-negotiables (canon discipline)
- One canonical home per asset (GitHub vs CoShare vs CoSources).
- No copy/paste canon across homes: use pointers + registry.
- LATEST files are pointers, not duplicated content.
- Every release ships receipts; crown-jewel changes are always receipted.
- If two items differ, treat as fork until reconciled.

---

## 2) Canonical Homes Policy (GitHub ↔ CoShare ↔ CoSources)
**GitHub:** collaboration + public snapshots (redacted).  
**CoShare:** private canon + crown jewels + ops runbooks.  
**CoSources:** evidence + standards radar + citations.

**Mirror rule:** Mirrors never become canon without explicit registry promotion.

---

## 3) Enforceable primitives
### 3.1 CanonicalPaths.yml (minimum keys)
- CanonicalPathsVersion
- MasterPlanLatest
- PointerRegistry
- CoShareRoot
- CoSourcesRoot
- InboxRoot
- ArchiveRoot
- PublicSnapshotsRoot

### 3.2 PointerRegistry.jsonl (minimum fields)
- asset_id, title, canonical_uri, mirrors[], version, sha256, owner, access_class, last_verified_utc

Hard fails:
- same asset_id with different canonical_uri
- same asset_id + same version with different sha256
- missing crown-jewel targets

---

## 4) Migration Wave Definition of Done
A wave is not done until:
1) canon homes declared  
2) CanonicalPaths updated (if needed) + dated changelog  
3) PointerRegistry updated + hashes recorded  
4) old locations frozen or pointer-stubbed  
5) receipts generated for crown-jewel touches  
6) drift/validate checks PASS (or manual equivalent)  
7) handoff note emitted (template below)

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

## 5) CoSources evidence discipline
Use **Citation Capture** (template included in bundle) for any non-trivial claim.
Minimum required fields:
- source pointer/URL
- accessed date (UTC)
- short excerpt (<=25 words)
- paraphrase
- confidence (0–1)
- counter-source if contested
- LAST-CHECKED

---

## 6) Repo + folder “Inspiration & Clarity” rubric (0–5 each)
- Clarity, Actionability, Canon visibility, Contributor comfort, Trust posture, Narrative

Thresholds:
- Seed minimum avg ≥ 3.5 and no category < 2
- Public-facing avg ≥ 4.0

Baseline repo files:
- README, CONTRIBUTING, CODE_OF_CONDUCT, LICENSE, SECURITY

Baseline folder file:
- `_INDEX.md` required

---

## 7) Top-50 prioritized additions (retained)
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

## 8) v7 add-ons (what changed from v6 MEGA)
- Bundle prior version FULL TEXT as appendices to eliminate 'it was in an older zip' ambiguity.
- Add Citation Capture template + required metadata to keep CoSources grounded and drift-resistant.
- Add Redaction Checklist template for any PUBLIC snapshot exports.
- Add JSON Schema for PointerRegistry entries (human + machine validation reference).
- Add Manifest verification script to let CoPrime verify extracted bundles quickly.
- Add 'Quality Budget' stop-the-line rule: if drift findings/staleness exceed thresholds, pause feature work until resolved.
- Add 'Repo About' examples template to improve inspiration + clarity consistently.

---

## 9) Bundle inventory
This zip includes:
- v7 MEGA doc + receipt + manifest
- `/tools/` — v5 tooling + v7 verify-manifest script
- `/templates/` — citation capture + redaction checklist + repo about examples
- `/schemas/` — PointerRegistry entry JSON schema reference
- `/previous/` — prior version zips (v2–v6)
- `/previous_extracted/` — extracted prior docs/receipts for convenience

---

## 10) Full prior doc text (embedded)
This appendix exists to eliminate “it was in an older version” omissions.

### CoPrime__Migration_Sanity_Checklist__v2__20260121.md
- Source zip: `CoPrime__Migration_Sanity_Checklist__v2__20260121.zip`
- SHA256 (extracted file): `45f437a27739540746bd5d3559fc718ab6310616a588d875392d40d919e00f81`

````md
# CoPrime Migration Sanity Checklist (v2) — GitHub → CoShare/CoSources
**Version:** v2  
**Date:** 20260121 (UTC build 20260121T152433Z)  
**Audience:** CoPrime (seed + soft launch)  
**Purpose:** A practical sanity checklist + optional improvements backlog for migrating from “GitHub-as-home” to “CoShare/CoSources/etc” **without** drift, regressions, integrity loss, or contributor confusion.

---

## 0) Regression + continuity guard (explicit)
This v2 **supersedes** v1 but does not erase it.

- v1 doc: `CoPrime__Migration_Sanity_Checklist__v1__20260121.md` SHA256 `e77a3d396ab1cd7f808c9c1b169b1a966c88754544aa76455567bdc8e864bb1f`
- v1 zip: `CoPrime__Migration_Sanity_Checklist__v1__20260121.zip` SHA256 `5697d810f447769dcd4bfaa97a28bd40782a99213ff3c6bdbae5e4c0491198da`

**Rule:** Future versions must not delete sections; mark old guidance **DEPRECATED** with pointers and keep receipts.

---

## 1) Operating rule (prevents 80% of migration failure)
**Every asset must have exactly one canonical home.** Everything else is a mirror, cache, or public snapshot.

Define (and then enforce) these homes:
- **GitHub (CoSuite org):** collaboration surface (code, docs-as-code, PR/issue workflow, public snapshots)
- **CoShare:** private canonical vault (crown jewels, private runbooks, big binaries, legal/patent materials)
- **CoSources:** evidence layer (standards, citations, “why we believe this” dossiers, best-practice notes)

**Sanity test:** if a new teammate asks “where is the truth?”, the answer must be unambiguous in <10 seconds.

---

## 2) Checklist: “No Forks, No Drift” (canonical paths + pointers)
1. **Canonical-paths file exists and is referenced everywhere**
   - One file that declares the canonical roots and “LATEST” pointers (CoShare roots, MasterPlan_LATEST, etc.).
2. **Pointer Registry exists**
   - For each important artifact: `AssetID`, `CanonicalURI`, `Mirrors[]`, `Version`, `SHA256`, `Owner`, `LastVerifiedUTC`, `AccessClass`.
3. **Read-only freeze rule for deprecated homes**
   - After cutover: old location becomes read-only (or contains only a pointer stub) to prevent shadow forks.
4. **Fork detection**
   - Job/ritual that flags:
     - multiple “LATEST” files
     - two different contents with the same name
     - mismatched hashes for “same version” assets
5. **Cutover plan is explicit**
   - “What moves”, “what stays”, “what mirrors”, and “what becomes a pointer-only stub”.

**Optional improvement:** Add “superseded-by” metadata to every moved asset so readers never land on dead ends.

---

## 3) Checklist: Data classification + access control (stop accidental leaks)
1. **Data classification exists**
   - `PUBLIC / INTERNAL / CONFIDENTIAL / CROWN-JEWEL` (or equivalent) with clear handling rules.
2. **Access control model exists for CoShare**
   - Roles, approvals, and break-glass process.
3. **Audit trail expectations are defined**
   - Who accessed what, when (at least for crown-jewel areas).
4. **Redaction rules exist for “public snapshot” exports**
   - What must be stripped before mirroring to GitHub.

---

## 4) Checklist: GitHub repo hygiene (identity, trust, and inspiration)
For every repo that remains in GitHub (code OR public snapshot repos):

1. **Repo short description is meaningful and motivational**
   - 120–160 chars; outcome + audience + why it matters.
2. **Topics/tags (discoverability)**
   - Minimum: product area, stage (seed/soft-launch), domain (XR/gaming), “CoCivium” tag set.
3. **README “above the fold” is optimized**
   - Mission statement (1–2 sentences)
   - Who it’s for (bullets)
   - What you can do in <30 minutes (starter path)
   - “Contribute” CTA + link to CONTRIBUTING
   - “Canon lives here” pointer (CoShare/CoSources as relevant)
4. **CONTRIBUTING.md exists**
   - First issue path, PR expectations, where canon lives.
5. **CODE_OF_CONDUCT.md exists**
6. **LICENSE is explicit**
7. **SECURITY.md exists**
8. **Release discipline**
   - Tags/releases for public snapshots; avoid “random main branch” being treated as authoritative.
9. **Issue/PR templates exist**
   - Bug/feature/doc/standards update templates with required fields.

---

## 5) Checklist: CoShare / CoSources folder hygiene (make storage inspiring, not a junk drawer)
For each top-level area (CoShare and CoSources):

1. **Every top-level folder has a short `_INDEX.md`**
   - What this folder is; what is canonical; what is mirrored; how to contribute.
2. **Naming conventions are enforced**
   - Dates `YYYYMMDD`, versions `vX.Y`, and “LATEST pointer files” (not content duplicates).
3. **“Do not fork canon” warning is visible**
4. **Receipts exist for crown-jewel artifacts**
   - Hash receipts + verification instructions.
5. **Sensitive vs shareable is obvious**
   - Consistent marker (“PUBLIC/PRIVATE” or folder policy).
6. **Retention + archiving rules exist**
   - What gets archived, when; immutable archive rules.
7. **Backup + restore playbook exists (CoShare)**
   - RPO/RTO targets and periodic test-restore.

---

## 6) Checklist: Documentation architecture (keeps growth from becoming chaos)
1. **Docs are categorized by intent**
   - Tutorials / How-to / Reference / Explanation.
2. **Docs change control**
   - Major docs require review.
3. **Link integrity**
   - Automated link checks (or periodic sweep) for pointers + references.
4. **Changelog discipline**
   - Dated entries: what changed / why.
5. **Glossary / CoTerms index exists**
   - Reduce terminology drift; link key terms.

---

## 7) Checklist: Operations + automation (integration without entropy)
1. **Automation entrypoints are centralized**
   - One obvious place to run/trigger standard tasks.
2. **Packaging is deterministic**
   - Re-running pack from same inputs yields same structure; document any non-determinism.
3. **CI checks align with governance**
4. **Session identity is treated as data**
   - Label + scope doc + pointers to canon.
5. **Observability for automation**
   - Logs, counters, and notifications (even if minimal).
6. **“Definition of Done” for migration waves**
   - Validation steps + receipts + handoff note.

---

## 8) Checklist: Integrity + trust rails (seed-friendly)
1. **Hash receipts exist for important packages**
2. **Artifact manifests exist**
   - A machine-readable manifest listing files + versions + hashes (recommended).
3. **Dependency hygiene**
   - Automated alerts; update cadence.
4. **SBOM baseline plan exists**
   - Decide a format and generate at release time (seed-compatible).
5. **Supply-chain integrity roadmap exists**
   - Later phase: signing/provenance/attestations (explicit plan prevents rework).

---

## 9) Checklist: Evidence layer (CoSources as “why we believe this”)
1. **Evidence ledger format exists**
   - `CLAIM`, `EVIDENCE`, `ASSUMPTION`, `RISK`, `SUPERSEDED-BY`.
2. **Supersession rules**
   - New guidance marks old guidance **SUPERSEDED** with pointers (do not delete).
3. **Recency sweep**
   - Every source gets a “last checked” date; stale sources are flagged.
4. **License/attribution policy**
   - Avoid copy/paste; prefer summaries + links + short quotes only when needed.

---

## 10) Sanity audit for CoPrime Master Plan and scope (mechanical, not vibes)
Run this as a periodic audit (monthly is fine in seed):

1. Scope boundaries (seed vs deferred “Not Now” list)
2. Single-canonical-paths (where LATEST truly lives; how forks are detected)
3. Dependency map (thin DAG, not a novel)
4. Risk register (top 10 failure modes + mitigations + owner)
5. Evidence ledger (claims with citations vs hypotheses)
6. Operational gates (what blocks merges/publishes; what is advisory)
7. Contributor experience (onboarding works in <30 min)
8. Narrative coherence (why stays stable while implementation evolves)
9. Packaging + receipts (everything important is verifiable)
10. Delta log (what changed since last audit)

---

## 11) Repo Description Upgrade Kit (copy/paste templates)
### 11.1 Short repo description (GitHub “About” field)
**Outcome** for **audience** by **mechanism**, with **stage**.
- Example: “Trust + reputation layer for XR communities enabling cross-platform signals without doxxing (seed).”

### 11.2 README opening (first ~30 seconds)
- What this is
- Who it’s for
- Start here (one quick path)
- Contribute (CTA + link)
- Canon (pointer)

### 11.3 CoCTA patterns (inspiration without spam)
- Invite: 3 starter tasks
- Signal: what good looks like (examples)
- Reward: credit policy
- Boundary: what we don’t accept

---

## 12) Top 50 additions to implement next (prioritized)
**How to use:** Start at #1 and stop when you hit capacity. The first ~12 prevent damage; the next ~20 improve integration; the rest lift quality toward “global best practice” territory.

1. Define & publish **Canonical Homes Policy** (GitHub vs CoShare vs CoSources) + enforcement language.
2. Ship a **Pointer Registry** schema (AssetID, CanonicalURI, Mirrors, Version, SHA256, Owner, LastVerifiedUTC, AccessClass).
3. Create a **Canonical Paths / LATEST Pointers** single file and treat it as the entrypoint for all automation.
4. Adopt a **No-Shadow-Forks** rule: deprecated homes become pointer-only + read-only + name reservation.
5. Add a **Data Classification** scheme (PUBLIC / INTERNAL / CONFIDENTIAL / CROWN-JEWEL) + handling rules.
6. Implement **Hash Receipt Standard** (file-level + package-level) + verification snippets (PS/macOS/Linux).
7. Add a **Versioning policy** (SemVer-ish for docs/assets) + what constitutes major/minor/patch.
8. Add **Changelog discipline**: every canonical doc has dated deltas + rationale + supersession pointers.
9. Define **Access Control** model for CoShare (roles, approvals, break-glass) + auditability expectations.
10. Create a **RACI** for migration + ongoing ops (owners for repos, docs, standards radar, automation).
11. Create a **Migration Cutover Playbook** (dry-run, freeze window, validation, rollback).
12. Add **Fork/Drift Detection** script spec (detect duplicate LATEST, mismatched hashes, duplicate names).
13. Define **Mirror Rules** (what mirrors to GitHub, what never does; how often; what format).
14. Add **Repo Description/README QA rubric** (scored checklist for inspiration + clarity).
15. Create **Contributor Funnel** spec: 30-minute onboarding path + starter issues + credits policy.
16. Add **Issue/PR templates** for each repo (bug, feature, doc, standards update) with required fields.
17. Add **Governance gates**: what requires review vs can be auto-merged; emergency fast path.
18. Adopt **Docs Architecture standard** (Diátaxis mapping + mandatory nav/index patterns).
19. Create **CoSources Evidence Ledger format** (CLAIM/EVIDENCE/ASSUMPTION/RISK/SUPERSEDED-BY).
20. Add a **Standards Radar** page spec (Adopt / Trial / Watch / Reject with dates + why).
21. Add a **Recency policy**: sources older than X get flagged; define X by domain.
22. Create **Link Integrity** checks (pointer links + references) as a routine/CI step.
23. Define **Naming Conventions** for files/folders (dates, versions, LATEST pointers, prefixes).
24. Define **Metadata fields** for folders (purpose, scope, owner, access class, retention).
25. Add **Retention + Archiving** policy (what gets archived, when; immutable archive rules).
26. Add **Backup + Restore** playbook for CoShare (RPO/RTO targets, test restores).
27. Add **Incident Response** mini-runbook (security leak, corrupted canon, bad release).
28. Add **Secrets Handling** rules (no secrets in repos; where secrets live; rotation cadence).
29. Add **Release Train** pattern (alpha/beta/seed) + what artifacts are produced each release.
30. Adopt **SBOM baseline** plan (format choice + generation step at releases).
31. Adopt **Dependency security** minimum (automated alerts + update cadence).
32. Adopt **Supply chain integrity** roadmap (commit signing, provenance/attestations) as later phase.
33. Add **Repo Health dashboard** spec (open issues, stale PRs, link failures, missing files).
34. Add **Docs Lint** spec (style, headings, broken links, front-matter presence).
35. Define **Single Entry Points** for automation (scripts/Makefile/PS modules) + docs.
36. Add **Deterministic Packaging** requirements (stable zip structure; normalized timestamps if needed).
37. Add **Artifact Manifest** standard (MANIFEST.json listing files, versions, hashes).
38. Add **Cross-repo dependency map** doc (what depends on what; update triggers).
39. Define **Environment separation** rules (dev/test/prod equivalents; what data can be used).
40. Define **Observability** for automation (logs, success/fail counters, notifications).
41. Add **Merge discipline** (branch naming, squash vs rebase, required checks).
42. Add **License/Attribution** policy for third-party sources in CoSources (avoid copy/paste; summarize).
43. Add **Brand/Voice guide** for repo descriptions + CoCTA tone consistency (seed appropriate).
44. Add **Public Snapshot policy**: what can be published; redaction rules; review step.
45. Add **Partner/vendor intake** checklist (NDA state, data sharing rules, storage location).
46. Add **Change request process** for standards/best practices (proposal → review → adopt).
47. Add **Decommission protocol** (how to retire repos/paths without breaking pointers).
48. Add **“Definition of Done”** for migration wave (validation steps + receipts + CoPrime note).
49. Add **Quarterly audit ritual** for Master Plan alignment (scope, evidence, risk, drift).

---

## 13) Optional improvements backlog (bucketed)
### MUST (prevents damage)
- Canonical homes + canonical paths + pointer registry
- Freeze/redirect rules for moved assets
- Hash receipts + manifests for crown jewels
- Master Plan sanity audit loop + risk register

### SHOULD (boosts integration quality)
- Repo description + README “above fold” upgrade sweep
- CONTRIBUTING + CODE_OF_CONDUCT + SECURITY baselines
- Evidence tagging + supersession rules + recency sweeps

### COULD (makes you “best practice in your own right”)
- Citation metadata + automated citation/link validation
- Standards Radar + Trust Posture page
- Supply-chain signing/provenance roadmap

---

## Changelog
- **v2 (20260121)** — Added regression/continuity guard, data classification/access control, manifests/observability, and a prioritized “Top 50 additions” list.
- **v1 (20260121)** — Initial checklist + improvement backlog + repo description kit.

````


### CoPrime__Migration_Sanity_Checklist__v3__20260121.md
- Source zip: `CoPrime__Migration_Sanity_Checklist__v3__20260121.zip`
- SHA256 (extracted file): `c2c100d811ce37468e1c304641a34f8f7f2e06527957cf0db9a47b8a7f358570`

````md
# CoPrime Migration Sanity Checklist (v3) — GitHub → CoShare/CoSources
**Version:** v3  
**Date:** 20260121 (UTC build 20260121T153531Z)  
**Audience:** CoPrime (seed + soft launch)  
**Purpose:** Migration sanity + operational best-practice upgrades, written to be **executable** (schemas, templates, and “definition of done” for waves).

---

## 0) Regression + continuity guard (explicit)
This v3 supersedes v2 and v1 but **does not erase them**.

- v1 doc: `CoPrime__Migration_Sanity_Checklist__v1__20260121.md` SHA256 `e77a3d396ab1cd7f808c9c1b169b1a966c88754544aa76455567bdc8e864bb1f`  
- v1 zip: `CoPrime__Migration_Sanity_Checklist__v1__20260121.zip` SHA256 `5697d810f447769dcd4bfaa97a28bd40782a99213ff3c6bdbae5e4c0491198da`  
- v2 doc: `CoPrime__Migration_Sanity_Checklist__v2__20260121.md` SHA256 `45f437a27739540746bd5d3559fc718ab6310616a588d875392d40d919e00f81`  
- v2 zip: `CoPrime__Migration_Sanity_Checklist__v2__20260121.zip` SHA256 `6e01e5f719e637db06b0d677727716b650572ae94651e090ce797488c2d56535`  

**Rule (non‑negotiable):**
- Never delete sections; mark obsolete guidance **DEPRECATED** + link to replacement.
- Every release includes hashes and a receipt.
- “LATEST” must be a pointer file, not a duplicate of content.

---

## 1) Canonical Homes Policy (the one page that prevents chaos)
**Every asset has exactly one canonical home.** Everything else is mirror/cache/snapshot.

**Canonical homes (seed defaults):**
- **GitHub:** collaboration surface (code, docs-as-code, PRs/issues, public snapshots)
- **CoShare:** private canonical vault (crown jewels, private runbooks, legal/patent, big binaries)
- **CoSources:** evidence layer (standards, citations, “why we believe this”, best-practice dossiers)

**Enforcement rule:**
- If something exists in two places with no pointer registry entry, treat it as **a fork** until proven otherwise.

---

## 2) Canonical Paths file (entrypoint for all automation)
Create exactly one canonical paths file that all automation reads first.

### 2.1 Required keys (minimum)
- `MasterPlanLatest`
- `PointerRegistry`
- `CoShareRoot`
- `CoSourcesRoot`
- `InboxRoot`
- `ArchiveRoot`
- `PublicSnapshotsRoot`

### 2.2 Example (YAML)
```yaml
# CanonicalPaths.yml  (canonical; referenced by every script)
MasterPlanLatest: "\\Server\CoCiviumAdmin\CoVault\CoCiviumAdmin\CoBux\MasterPlan\MasterPlan_LATEST.md"
PointerRegistry:  "\\Server\CoCiviumAdmin\CoVault\CoCiviumAdmin\CoBux\Registry\PointerRegistry.jsonl"
CoShareRoot:      "\\Server\CoCiviumAdmin\CoVault\CoShare"
CoSourcesRoot:    "\\Server\CoCiviumAdmin\CoVault\CoSources"
InboxRoot:        "\\Server\CoCiviumAdmin\CoVault\CoBux\INBOX"
ArchiveRoot:      "\\Server\CoCiviumAdmin\CoVault\CoBux\ARCHIVE"
PublicSnapshotsRoot: "\\Server\CoCiviumAdmin\CoVault\PublicSnapshots"
```
**Rule:** No script is allowed to run without successfully loading this file (hard fail).

---

## 3) Pointer Registry (machine-readable, fork-proof)
Use a single registry to declare canon + mirrors + hashes.

### 3.1 Format recommendation
Use **JSON Lines** (one JSON object per line) so you can append safely and diff easily.

### 3.2 Minimal schema (required fields)
- `asset_id` (stable)
- `title`
- `canonical_uri`
- `mirrors` (array)
- `version`
- `sha256`
- `owner`
- `access_class` (`PUBLIC|INTERNAL|CONFIDENTIAL|CROWN_JEWEL`)
- `last_verified_utc`

### 3.3 Example entry (JSONL)
```json
{"asset_id":"COPRIME-MIG-CHK","title":"CoPrime Migration Sanity Checklist","canonical_uri":"\\\\Server\\CoVault\\CoBux\\Docs\\CoPrime__Migration_Sanity_Checklist__v3__20260121.md","mirrors":["https://github.com/CoCivium/.../releases/..."],"version":"v3","sha256":"<sha256>","owner":"CoPrime","access_class":"INTERNAL","last_verified_utc":"20260121T153531Z"}
```

### 3.4 Mandatory behaviors
- Canon changes require new `version` and new `sha256`.
- Mirrors never become canonical unless explicitly promoted in registry + paths file.
- If two assets claim same `asset_id` and different hashes → **block publish** until resolved.

---

## 4) Data classification + access control (stop accidental leaks)
### 4.1 Class definitions (seed-simple)
- `PUBLIC` — safe to mirror to GitHub
- `INTERNAL` — ok for collaborators, not public
- `CONFIDENTIAL` — restricted, needs explicit approval to share
- `CROWN_JEWEL` — must never leave CoShare; export only as redacted, review-required snapshots

### 4.2 Required controls
- CoShare: role-based access + break-glass procedure.
- Public snapshot export: redaction checklist + signoff.

---

## 5) “Definition of Done” for a migration wave (copy/paste)
A migration wave is not “done” until these pass:

1. Canonical homes declared (what moved, what stayed, what mirrors).
2. Canonical Paths updated (if needed) with dated changelog entry.
3. Pointer Registry updated with new entries/versions/hashes.
4. Old locations frozen (read-only) OR replaced with pointer-only stubs.
5. Hash receipts generated for any crown-jewel artifact touched.
6. Drift scan run (duplicate LATEST, dup names, mismatched hashes).
7. Repo hygiene checks run for any affected repos (see §6 rubric).
8. Short handoff note emitted to CoPrime with pointers + hashes.

---

## 6) Repo Description + README “Inspiration & Clarity” Rubric (scored)
Use this for a sweep across repos and key folders.

### 6.1 Scoring (0–5 each)
- **Clarity:** what it is, for whom, why it matters
- **Actionability:** a 30-minute “Start here” path exists
- **Canon visibility:** clearly states where truth lives (and links it)
- **Contributor comfort:** contributing path, conduct, and expectations reduce anxiety
- **Trust posture:** license, security contact, release discipline
- **Narrative:** coherent mission line that makes people want to help

### 6.2 Pass/fail thresholds
- Seed minimum: average ≥ 3.5 and no category < 2.
- Public-facing repos: average ≥ 4.0.

### 6.3 Required repo files (seed baseline)
- README.md
- CONTRIBUTING.md
- CODE_OF_CONDUCT.md
- LICENSE
- SECURITY.md (even minimal)

---

## 7) CoMetaTrain + CoCTA spec (make it consistent, not vibes)
If you want “continuous integration + inspiration” you need a **schema**.

### 7.1 Minimal front-matter keys (recommended for READMEs or docs)
```yaml
co_stage: seed|soft_launch|later
co_cta_primary: "Open an issue with your use-case"
co_cta_secondary: "Pick a starter task"
co_metatrain_tags: ["xr","reputation","privacy","integrity","automation"]
co_owner: "CoPrime"
co_last_reviewed: "2026-01-21"
```
### 7.2 CoCTA rules
- No more than **2 CTAs above the fold**.
- CTA must match stage (seed CTAs are “help us validate”, not “join the movement”).

### 7.3 CoMetaTrain rules
- Every important doc includes **3 links**:
  - upstream sources (CoSources evidence)
  - downstream action (issue/PR/task)
  - canonical pointer (registry entry)

---

## 8) Evidence layer executable format (CoSources)
Use a consistent, grep-friendly pattern:

```
CLAIM: ...
EVIDENCE: <url or doc pointer>
ASSUMPTION: ...
RISK: ...
SUPERSEDED-BY: <pointer>
LAST-CHECKED: YYYY-MM-DD
```
**Rule:** guidance without LAST-CHECKED is treated as stale.

---

## 9) Drift/Fork detector (spec)
Minimum detections:
- Multiple files named `*_LATEST.*` where content differs.
- Duplicate basenames with different hashes in canonical roots.
- Pointer registry references missing targets.
- Targets without registry entries (canon not declared).
- “Same version” with different hash.

Output should be a single machine-readable report plus a human summary.

---

## 10) Master Plan sanity audit (mechanical)
Monthly audit must output:
- Scope: seed vs deferred “Not Now” list
- Dependency DAG (thin)
- Top 10 risks + owners
- Evidence ledger deltas (what is now supported vs still assumed)
- Ops gates status (what is enforced vs advisory)
- Contributor funnel pass rate (can a new person contribute in <30 min?)

---

## 11) Top next actions for CoPrime (if you do nothing else)
1. Create CanonicalPaths.yml and hard-fail all scripts without it.
2. Create PointerRegistry.jsonl and start recording hashes for crown-jewel assets.
3. Run a repo description/README sweep using the rubric and fix the worst 10 first.
4. Define data classification and label crown-jewel areas.
5. Write the Migration Wave DoD into your process and enforce it.
6. Create the CoMetaTrain/CoCTA front-matter convention and apply it to top repos.
7. Stand up a drift detector (even if manual weekly at first) and record results.

---

## Changelog
- **v3 (20260121)** — Added executable specs: CanonicalPaths.yml spec, PointerRegistry JSONL schema + behaviors, migration wave DoD, repo rubric scoring, CoMetaTrain/CoCTA schema, drift detector spec, and “Top next actions” section.
- **v2 (20260121)** — Added data classification/access control + manifests/observability concepts + prioritized “Top 50 additions” list.
- **v1 (20260121)** — Initial checklist + improvement backlog + repo description kit.

````


### CoPrime__Migration_Sanity_Checklist__v4__20260121.md
- Source zip: `CoPrime__Migration_Sanity_Checklist__v4__20260121.zip`
- SHA256 (extracted file): `637e78ebc59a971e3399af59b2f0110a591621a157795c3b67575eb6b13d1c80`

````md
# CoPrime Migration Sanity Checklist (v4) — GitHub → CoShare/CoSources
**Version:** v4  
**Date:** 20260121 (UTC build 20260121T160650Z)  
**Audience:** CoPrime (seed + soft launch)  
**Purpose:** Migration sanity + operational upgrades, written to be **executable** (schemas, templates, wave DoD, and a validator spec).

---

## 0) Regression + continuity guard (explicit)
This v4 supersedes v3/v2/v1 but **does not erase them**.

- v1 doc: `CoPrime__Migration_Sanity_Checklist__v1__20260121.md` SHA256 `e77a3d396ab1cd7f808c9c1b169b1a966c88754544aa76455567bdc8e864bb1f`  
- v1 zip: `CoPrime__Migration_Sanity_Checklist__v1__20260121.zip` SHA256 `5697d810f447769dcd4bfaa97a28bd40782a99213ff3c6bdbae5e4c0491198da`  
- v2 doc: `CoPrime__Migration_Sanity_Checklist__v2__20260121.md` SHA256 `45f437a27739540746bd5d3559fc718ab6310616a588d875392d40d919e00f81`  
- v2 zip: `CoPrime__Migration_Sanity_Checklist__v2__20260121.zip` SHA256 `6e01e5f719e637db06b0d677727716b650572ae94651e090ce797488c2d56535`  
- v3 doc: `CoPrime__Migration_Sanity_Checklist__v3__20260121.md` SHA256 `c2c100d811ce37468e1c304641a34f8f7f2e06527957cf0db9a47b8a7f358570`  
- v3 zip: `CoPrime__Migration_Sanity_Checklist__v3__20260121.zip` SHA256 `2af46e25c42a6dc80bfef23a6bcf250f0623389d2f210c7e53087c84317e72fe`  

**Rules (non‑negotiable):**
- Never delete sections; mark obsolete guidance **DEPRECATED** + link to replacement.
- Every release includes hashes and a receipt.
- “LATEST” must be a **pointer file**, not a duplicate of content.

---

## 1) Two-hour QuickStart (do this first; everything else builds on it)
If CoPrime has only **2 hours**, do these in order:

1. Create `CanonicalPaths.yml` (single entrypoint for every script)
2. Create `PointerRegistry.jsonl` (append-only registry of canon + mirrors + hashes)
3. Add “Migration Wave DoD” to your working process (copy/paste in §6)
4. Run a “Repo About/README sweep” on the worst 10 repos/folders (rubric §7)
5. Start labeling crown-jewel areas (data classification §5)

**Stop here** until those exist. Anything else before this increases drift risk.

---

## 2) Canonical Homes Policy (prevents chaos)
**Every asset has exactly one canonical home.** Everything else is mirror/cache/snapshot.

Seed defaults:
- **GitHub:** collaboration surface (code, docs-as-code, PRs/issues, public snapshots)
- **CoShare:** private canonical vault (crown jewels, private runbooks, legal/patent, big binaries)
- **CoSources:** evidence layer (standards, citations, “why we believe this”, best-practice dossiers)

Enforcement:
- If something exists in two places with no registry entry, treat it as **a fork** until proven otherwise.

---

## 3) CanonicalPaths.yml (entrypoint for all automation)
**Hard requirement:** No script runs unless it loads this file successfully (hard fail).

### 3.1 Required keys (minimum)
- `MasterPlanLatest`
- `PointerRegistry`
- `CoShareRoot`
- `CoSourcesRoot`
- `InboxRoot`
- `ArchiveRoot`
- `PublicSnapshotsRoot`
- `CanonicalPathsVersion`

### 3.2 Example (YAML)
```yaml
# CanonicalPaths.yml  (canonical; referenced by every script)
CanonicalPathsVersion: "v1"
MasterPlanLatest: "\\Server\CoCiviumAdmin\CoVault\CoCiviumAdmin\CoBux\MasterPlan\MasterPlan_LATEST.md"
PointerRegistry:  "\\Server\CoCiviumAdmin\CoVault\CoCiviumAdmin\CoBux\Registry\PointerRegistry.jsonl"
CoShareRoot:      "\\Server\CoCiviumAdmin\CoVault\CoShare"
CoSourcesRoot:    "\\Server\CoCiviumAdmin\CoVault\CoSources"
InboxRoot:        "\\Server\CoCiviumAdmin\CoVault\CoBux\INBOX"
ArchiveRoot:      "\\Server\CoCiviumAdmin\CoVault\CoBux\ARCHIVE"
PublicSnapshotsRoot: "\\Server\CoCiviumAdmin\CoVault\PublicSnapshots"
```

### 3.3 CanonicalPaths change discipline
- Any edit requires a changelog entry (date + what + why)
- Any edit triggers a drift scan (see §9)

---

## 4) PointerRegistry.jsonl (machine-readable, fork-proof)
### 4.1 Format
Use **JSON Lines** so you can append safely and diff easily.

### 4.2 Required fields
- `asset_id` (stable)
- `title`
- `canonical_uri`
- `mirrors` (array)
- `version`
- `sha256`
- `owner`
- `access_class` (`PUBLIC|INTERNAL|CONFIDENTIAL|CROWN_JEWEL`)
- `last_verified_utc`

### 4.3 Example entry (JSONL)
```json
{"asset_id":"COPRIME-MIG-CHK","title":"CoPrime Migration Sanity Checklist","canonical_uri":"\\\\Server\\CoVault\\CoBux\\Docs\\CoPrime__Migration_Sanity_Checklist__v4__20260121.md","mirrors":["https://github.com/CoCivium/.../releases/..."],"version":"v4","sha256":"<sha256>","owner":"CoPrime","access_class":"INTERNAL","last_verified_utc":"20260121T160650Z"}
```

### 4.4 Mandatory behaviors
- Canon changes require new `version` and new `sha256`.
- Mirrors never become canonical unless explicitly promoted in registry + paths file.
- Same `asset_id` + different hash → **block publish** until resolved.

---

## 5) Data classification + access control (stop accidental leaks)
### 5.1 Class definitions (seed-simple)
- `PUBLIC` — safe to mirror to GitHub
- `INTERNAL` — ok for collaborators, not public
- `CONFIDENTIAL` — restricted, explicit approval to share
- `CROWN_JEWEL` — must never leave CoShare; export only as redacted, review-required snapshots

### 5.2 Minimum controls
- CoShare: role-based access + break-glass procedure.
- Public snapshot export: redaction checklist + signoff.
- Secrets: **never** in repos; declare where secrets live and how they rotate.

---

## 6) Migration Wave “Definition of Done” (copy/paste)
A wave is not done until these pass:

1. Canonical homes declared (what moved, what stayed, what mirrors).
2. CanonicalPaths updated (if needed) with dated changelog entry.
3. PointerRegistry updated with new entries/versions/hashes.
4. Old locations frozen (read-only) OR replaced with pointer-only stubs.
5. Hash receipts generated for any crown-jewel artifact touched.
6. Drift scan run (duplicate LATEST, dup names, mismatched hashes).
7. Repo hygiene checks run for any affected repos (rubric §7).
8. Short handoff note emitted (template §12).

**Wave output requirement:** include a receipt and a “what changed” summary.

---

## 7) Repo + Folder “Inspiration & Clarity” Rubric (scored)
Use this on GitHub repos and key CoShare/CoSources folders (via `_INDEX.md`).

### 7.1 Score (0–5 each)
- **Clarity:** what it is, for whom, why it matters
- **Actionability:** a 30-minute “Start here” exists
- **Canon visibility:** clearly states where truth lives (pointer)
- **Contributor comfort:** contributing path lowers anxiety
- **Trust posture:** license/security/release discipline baseline
- **Narrative:** mission line that makes people want to help

### 7.2 Thresholds
- Seed minimum: avg ≥ 3.5 and no category < 2.
- Public-facing: avg ≥ 4.0.

### 7.3 Baseline repo files (seed)
- README.md
- CONTRIBUTING.md
- CODE_OF_CONDUCT.md
- LICENSE
- SECURITY.md

### 7.4 Baseline folder files (CoShare/CoSources)
- `_INDEX.md` (required template §11)

---

## 8) CoMetaTrain + CoCTA spec (consistent, stage-aware)
### 8.1 Minimal front-matter keys
```yaml
co_stage: seed|soft_launch|later
co_cta_primary: "Open an issue with your use-case"
co_cta_secondary: "Pick a starter task"
co_metatrain_tags: ["xr","reputation","privacy","integrity","automation"]
co_owner: "CoPrime"
co_last_reviewed: "20260121"
```
### 8.2 Rules
- Max **2 CTAs** above the fold.
- Every key doc has 3 links: upstream evidence (CoSources), downstream action (issue/task), canonical pointer (registry).

---

## 9) Drift/Fork detector spec (minimum viable)
Detections:
- Multiple files named `*_LATEST.*` where content differs
- Duplicate basenames with different hashes in canonical roots
- Pointer registry references missing targets
- Targets without registry entries (canon not declared)
- “Same version” with different hash

Outputs:
- machine-readable report (JSON)
- human summary (top 10 failures + what to do next)
- exit code non-zero if any **MUST** rule fails

---

## 10) Validator tool spec (turn the checklist into enforcement)
### 10.1 CLI surface (minimal)
- `coprime validate --paths CanonicalPaths.yml`
- `coprime drift-scan --paths CanonicalPaths.yml`
- `coprime receipt --in <file_or_folder> --out <receipt.txt>`
- `coprime manifest --in <folder> --out MANIFEST.json`

### 10.2 Validation rules (hard fail)
- CanonicalPaths.yml loads and contains required keys
- PointerRegistry exists and is parseable JSONL
- No duplicate `asset_id` values with different canonical_uri
- No duplicate `asset_id` values with different sha256 for same version
- All registry `canonical_uri` targets exist
- All `*_LATEST*` are pointer-only files (convention; content must be a pointer record, not full doc)

### 10.3 Validation rules (warn)
- missing `_INDEX.md` in canonical folders
- missing baseline repo files
- docs missing `co_last_reviewed`
- stale evidence entries (LAST-CHECKED older than policy)

---

## 11) Templates (copy/paste)
### 11.1 `_INDEX.md` template for CoShare/CoSources folders
```md
# <Folder Name> — Index

**Purpose:**  
**Canonical here:**  
**Mirrors:**  
**Owner:**  
**Access class:** PUBLIC | INTERNAL | CONFIDENTIAL | CROWN_JEWEL  
**Last reviewed:** YYYY-MM-DD  

## Start here
- <link to the one doc new people should read first>

## What lives here
- <bullet list>

## Anti-fork rule
If you need this content elsewhere, create a pointer + registry entry. Do not copy/paste canon.
```

### 11.2 Repo “About” field template (120–160 chars)
**Outcome** for **audience** by **mechanism**, with **stage**.

### 11.3 Evidence ledger block template (CoSources)
```
CLAIM: ...
EVIDENCE: <link/pointer>
ASSUMPTION: ...
RISK: ...
SUPERSEDED-BY: <pointer>
LAST-CHECKED: YYYY-MM-DD
```

---

## 12) CoPrime handoff note template (pasteable)
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

## 13) Health metrics (so this stays “best practice” over time)
Track weekly (even manually at first):
- # of drift-scan failures
- # of missing baseline repo files
- % of top docs with `co_last_reviewed` within 30 days
- # of evidence ledger items older than policy
- median “time to first contribution” (fresh contributor)
- # of crown-jewel items lacking receipts

If these worsen, treat it as operational debt and fix before adding new surface area.

---

## 14) Where v5 would go (and why v4 is near the plateau)
Beyond v4, improvements are mostly **implementation work**, not checklist text:
- actually building the validator/drift-scan scripts
- wiring CI/automation to enforce rules
- performing the repo/folder sweeps and recording scores
- setting up a standards radar pipeline

That’s why v4 is close to the “diminishing returns” point for document-only evolution.

---

## Changelog
- **v4 (20260121)** — Added 2-hour QuickStart, validator CLI spec, templates, handoff note template, and weekly health metrics.
- **v3 (20260121)** — Added executable specs (CanonicalPaths + PointerRegistry + wave DoD + rubric + CoMetaTrain/CoCTA + drift detector).
- **v2 (20260121)** — Added data classification/access control + prioritized additions.
- **v1 (20260121)** — Initial checklist.

````


### CoPrime__Migration_Sanity_Checklist__v5__20260121.md
- Source zip: `CoPrime__Migration_Sanity_Checklist__v5__20260121.zip`
- SHA256 (extracted file): `903105d8a90c1854bbc1fe8a3ce8fcc2ac211a34058d9bd3f288c1061f50da83`

````md
# CoPrime Migration Sanity Checklist (v5) — GitHub → CoShare/CoSources
**Version:** v5  
**Date:** 20260121 (UTC build 20260121T165009Z)  
**Audience:** CoPrime (seed + soft launch)  
**Purpose:** Migration sanity + operational upgrades, written to be **enforceable** (schemas + templates + runnable seed-minimal tooling included in the bundle).

---

## 0) Continuity guard (explicit)
v5 supersedes v4/v3/v2/v1 but does not erase them.

- v1 doc `e77a3d396ab1cd7f808c9c1b169b1a966c88754544aa76455567bdc8e864bb1f` ; v1 zip `5697d810f447769dcd4bfaa97a28bd40782a99213ff3c6bdbae5e4c0491198da`  
- v2 doc `45f437a27739540746bd5d3559fc718ab6310616a588d875392d40d919e00f81` ; v2 zip `6e01e5f719e637db06b0d677727716b650572ae94651e090ce797488c2d56535`  
- v3 doc `c2c100d811ce37468e1c304641a34f8f7f2e06527957cf0db9a47b8a7f358570` ; v3 zip `2af46e25c42a6dc80bfef23a6bcf250f0623389d2f210c7e53087c84317e72fe`  
- v4 doc `637e78ebc59a971e3399af59b2f0110a591621a157795c3b67575eb6b13d1c80` ; v4 zip `1054f9f9e13d80001d4ae27d14afd2765746b01214da6a374cf78d3f590ed402`  

Rules:
- Never delete sections; mark obsolete guidance **DEPRECATED** + link to replacement.
- Every release includes hashes and a receipt.
- “LATEST” must be a pointer file, not a duplicate of content.

---

## 1) What’s new vs v4 (material improvements)
v4 hit the plateau for prose. v5 adds runnable enforcement:

Included in this bundle:
- `CanonicalPaths.template.yml`
- `PointerRegistry.template.jsonl`
- `coprime.validate.ps1`
- `coprime.drift_scan.ps1`
- `coprime.manifest.ps1`
- `TOOLS_README.md`

These are seed-minimal, dependency-free, and meant to be extended.

---

## 2) QuickStart (15 minutes)
1) Copy `CanonicalPaths.template.yml` → `CanonicalPaths.yml` and edit paths.
2) Create the file at `PointerRegistry:` (start with `PointerRegistry.template.jsonl`).
3) Run:
```powershell
./coprime.validate.ps1 -PathsFile .\CanonicalPaths.yml
./coprime.drift_scan.ps1 -PathsFile .\CanonicalPaths.yml -OutReport .\drift_report.json
```
4) Fix failures before moving more canon.

---

## 3) Canonical Homes Policy
Every asset has exactly one canonical home. Everything else is mirror/cache/snapshot.

Seed defaults:
- GitHub = collaboration + public snapshots
- CoShare = private canonical vault
- CoSources = evidence/citations/standards layer

If the same thing exists in two places without a registry entry, treat it as a fork.

---

## 4) CanonicalPaths.yml
Hard requirement: scripts hard-fail if missing/unparseable.

Required keys:
- CanonicalPathsVersion, MasterPlanLatest, PointerRegistry,
  CoShareRoot, CoSourcesRoot, InboxRoot, ArchiveRoot, PublicSnapshotsRoot

Implementation note: tools parse only **flat** YAML `key: value` lines.

---

## 5) PointerRegistry.jsonl
Required fields:
- asset_id, title, canonical_uri, mirrors[], version, sha256, owner, access_class, last_verified_utc

Hard-fail conditions enforced by `coprime.validate.ps1`:
- missing required fields
- invalid sha256
- same asset_id with different canonical_uri
- same asset_id + same version with different sha256
- missing CROWN_JEWEL canonical target

---

## 6) Migration Wave Definition of Done
A wave is not done until:
- registry updated + hashes recorded
- validate PASS
- drift-scan PASS
- old location frozen/pointer-stubbed
- receipt created for crown-jewel touches

---

## 7) Where v6 would go
Past v5, improvements are mostly operational execution:
- wire validate/drift-scan into CI or scheduled checks
- actually run rubric sweeps and record scores
- build a Standards Radar pipeline in CoSources

Doc-only v6 would not be much better unless it ships more tooling or real measured results.

---

## Changelog
- v5 — bundle includes runnable tooling (validate/drift-scan/manifest) + templates.
- v4 — validator spec + templates + metrics.
- v3 — executable schemas.
- v2 — top-50 list + access controls.
- v1 — initial.

````


### CoPrime__Migration_Sanity_Checklist__v6__MEGA__20260121.md
- Source zip: `CoPrime__Migration_Sanity_Checklist__v6__MEGA__20260121.zip`
- SHA256 (extracted file): `be355149db79240bf0c1b29a284789f3a5601eecf5f5026dae8221dd9b0969bb`

````md
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

````


### TOOLS_README.md
- Source zip: `CoPrime__Migration_Sanity_Checklist__v5__20260121.zip`
- SHA256 (extracted file): `ff50e947e3c61166c3c2b62b5744c9e50638531810676f5aae6b427831b8881e`

````md
# CoPrime Tools (v5 bundle)
Build: 20260121T165009Z

These scripts are **seed-minimal** and avoid external dependencies.
Assumptions:
- PowerShell 7+
- CanonicalPaths is a **flat** YAML of `key: value` pairs (no nesting)

## Files
- `coprime.validate.ps1` — Validate CanonicalPaths + PointerRegistry + basic invariants
- `coprime.drift_scan.ps1` — Detect common drift/fork conditions (LATEST collisions, dup basenames)
- `coprime.manifest.ps1` — Create a MANIFEST.json (files + sha256) for a folder
- `CanonicalPaths.template.yml` — Template for CanonicalPaths
- `PointerRegistry.template.jsonl` — One-line example entry for PointerRegistry JSONL

## Typical usage (PowerShell)
```powershell
# Validate invariants
./coprime.validate.ps1 -PathsFile .\CanonicalPaths.yml

# Drift scan
./coprime.drift_scan.ps1 -PathsFile .\CanonicalPaths.yml -OutReport .\drift_report.json

# Generate manifest for a folder
./coprime.manifest.ps1 -InDir .\SomePackage -OutFile .\MANIFEST.json
```

## Notes
- Conservative: if something looks like a fork, fail fast.
- Extend over time: add more roots, more strict checks, CI wiring.

````

