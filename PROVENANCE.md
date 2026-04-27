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

This repository is currently documentation/specification-only. No executable verification command is claimed here. No GitHub Actions workflow or other CI verifier is provided in-repo at this time; any prior text suggesting that `.github/workflows/verify-chain.yml` runs on push/PR was inaccurate and has been removed.

A reader who wishes to independently check internal consistency between artifact bytes and `CHAIN_INDEX.json` may do so with their own tooling by computing SHA-256 of files under `artifacts/` and comparing each result to the corresponding `sha256` entry in `CHAIN_INDEX.json`. The expected semantics of each status are:

- Every **SEALED** artifact should exist and match its SHA-256.
- Every **PROVISIONAL** artifact should exist and match its SHA-256.
- Every **MISSING** artifact should be absent (or handled only via an explicitly appended remediation run).

Such a check, even when it succeeds, establishes only internal consistency between bytes in this repository and a hash index also in this repository. It is not a provenance proof.

## Evidence boundary

VaultGhost verifies records within a captured boundary. It can verify hashes, signatures, schemas, timestamps, declared metadata, and replayable artifacts. It does not claim visibility into hidden model weights, provider-side logs, undisclosed system prompts, or private infrastructure.

A valid signature is not trusted identity. Internal consistency is not provenance.

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
