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
