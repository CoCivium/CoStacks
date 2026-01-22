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
