# VaultGhost — Chain Artifacts (Audit Pack)

This repository contains the **byte-level artifacts** and **hash index** used to describe a VaultGhost run chain. It is currently documentation/specification-only: the hash index and artifacts are present, but no executable verification command is claimed by this repository.

## Current chain status

- RUN-003 → RUN-005 → RUN-006 → RUN-007C: **SEALED**
- RUN-008: **MISSING (documented)**
- RUN-009: **PROVISIONAL (locally-derived; caveated)**

See `PROVENANCE.md` for definitions and interpretation guidance.

## How to verify

This repository is currently documentation/specification-only. No executable verification command is claimed here.

A reader who wishes to independently check internal consistency between artifact bytes and `CHAIN_INDEX.json` may compute SHA-256 hashes of files in `artifacts/` and compare them to the entries in `CHAIN_INDEX.json` using their own tooling. No CI, GitHub Actions workflow, or other automated verifier is provided in this repository at this time.

## Repository structure

- `CHAIN_INDEX.json`: authoritative hash index for run artifacts
- `artifacts/`: immutable run artifacts
- `PROVENANCE.md`: audit glossary + remediation runbook

## Evidence boundary

VaultGhost verifies records within a captured boundary. It can verify hashes, signatures, schemas, timestamps, declared metadata, and replayable artifacts. It does not claim visibility into hidden model weights, provider-side logs, undisclosed system prompts, or private infrastructure.

A valid signature is not trusted identity. Internal consistency is not provenance.

## Integrity note (tell it like it is)

Even where consistency between artifacts and `CHAIN_INDEX.json` can be checked, that check establishes only *internal consistency*. To harden against a malicious maintainer, consider:
- branch protection + required reviews,
- signed commits/tags,
- and an external timestamp/attestation of the `CHAIN_INDEX.json` hash.
