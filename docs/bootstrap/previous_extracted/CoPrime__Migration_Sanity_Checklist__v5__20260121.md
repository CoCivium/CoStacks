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
