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
