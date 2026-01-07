# VaultGhost Chain Provenance (Audit Glossary)

Last updated (UTC): 2026-01-07 11:01:20Z

This repository is an **audit-oriented artifact pack** for the VaultGhost run chain.  
It is intentionally strict about *what bytes exist*, *what bytes are sealed*, and *where provenance breaks*.

## Status definitions

- **SEALED**: Artifact bytes are present and their SHA-256 matches `CHAIN_INDEX.json`.
- **PROVISIONAL**: Artifact bytes are present and hashed, but provenance is **local-only** (not externally-originated) or otherwise caveated.
- **MISSING**: Artifact bytes are **not present**. A receipt documents the absence and remediation path.
- **SUPERSEDED**: A later artifact/receipt replaces this entry without rewriting history (append-only remediation).

## Chain topology (current)

```
RUN-003 → RUN-005 → RUN-006 → RUN-007C   [SEALED]
                                  ↓
                                RUN-008  [MISSING — documented]
                                  ↓
                                RUN-009  [PROVISIONAL — locally-derived]
```

### What the break means (plain language)

- Any claim that **RUN-008 was executed** is invalid unless the *raw RUN-008 JSON bytes* are present and hashed.
- RUN-009 is publishable, but must be described as **locally-derived** (and not as a Perplexity-executed agent demo lineage).

## Verification

### CI
GitHub Actions runs `.github/workflows/verify-chain.yml` on each push/PR and verifies:
- Every **SEALED** artifact exists and matches its SHA-256.
- Every **PROVISIONAL** artifact exists and matches its SHA-256.
- Every **MISSING** artifact is absent (or is handled only via an explicitly appended remediation run).

### Local
From repo root:

```bash
python3 - <<'PY'
import json, hashlib, os, sys
def sha256_file(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for c in iter(lambda: f.read(1<<20), b''):
            h.update(c)
    return h.hexdigest()
idx=json.load(open('CHAIN_INDEX.json','r'))
ok=True
for run in idx['runs']:
    for a in run['artifacts']:
        p=os.path.join('artifacts', a['file_name'])
        status=a['status']
        if status in ('SEALED','PROVISIONAL'):
            if not os.path.exists(p):
                print('MISSING FILE:', p); ok=False; continue
            got=sha256_file(p)
            if got.lower()!=a['sha256'].lower():
                print('HASH MISMATCH:', p, a['sha256'], got); ok=False
        elif status=='MISSING':
            if os.path.exists(p):
                print('UNEXPECTED PRESENT FILE (should be missing):', p); ok=False
print('OK' if ok else 'FAIL'); sys.exit(0 if ok else 1)
PY
```

## Repair runbook (RUN-008)

Goal: produce a new externally-originated artifact without rewriting history.

1. Execute Prompt 3 in the intended system (Perplexity/Comet agent demo).
2. Export or copy **full raw JSON** bytes.
3. Save as `RUN-008_agent_demo.json` (exact bytes).
4. Create a new run (recommended: `RUN-010_REPAIR_RUN008`) that:
   - hashes the new artifact,
   - links back to `RUN-008_MISSING_ARTIFACT_RECEIPT.json`,
   - marks RUN-008 missing receipt as **SUPERSEDED** (do not delete it).

Principle: **append-only remediation**.
