# VaultGhost — Chain Artifacts (Audit Pack)

This repository contains the **byte-level artifacts** and **hash index** used to validate a VaultGhost run chain.

## Current chain status

- RUN-003 → RUN-005 → RUN-006 → RUN-007C: **SEALED**
- RUN-008: **MISSING (documented)**
- RUN-009: **PROVISIONAL (locally-derived; caveated)**

See `PROVENANCE.md` for definitions and interpretation guidance.

## Phase 0 Quickstart

The **Phase 0 disclosure bundle** provides the scaffolding for transparent documentation of the VaultGhost chain. To verify the bundle integrity:

```bash
# Clone the repository
git clone https://github.com/drosenbluth25/vaultghost-chain-ledger.git
cd vaultghost-chain-ledger

# Generate bundle digest
./generate_bundle_digest.sh

# Compare with published digest in PUBLICATION_RECORD_TEMPLATE.md
```

For complete documentation, see:
- `FINAL_INDEX.md` — Complete list of Phase 0 files
- `VERIFICATION_GUIDE.md` — Detailed verification instructions
- `DISCLOSURE_RATIONALE.md` — Why Phase 0 exists

## How to verify

- **CI**: GitHub Actions runs `verify-chain` on every push/PR.
- **Local**: Use the verification snippet in `PROVENANCE.md`.

## Repository structure

- `CHAIN_INDEX.json`: authoritative hash index for run artifacts
- `artifacts/`: immutable run artifacts
- `.github/workflows/verify-chain.yml`: CI verifier
- `PROVENANCE.md`: audit glossary + remediation runbook

## Integrity note (tell it like it is)

CI verifies *internal consistency* between artifacts and `CHAIN_INDEX.json`.  
To harden against a malicious maintainer, add:
- branch protection + required reviews,
- signed commits/tags,
- and an external timestamp/attestation of the `CHAIN_INDEX.json` hash.
