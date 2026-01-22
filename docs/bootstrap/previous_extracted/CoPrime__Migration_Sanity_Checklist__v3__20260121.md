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
