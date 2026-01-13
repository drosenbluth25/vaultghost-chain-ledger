# Phase 0 Disclosure — Verification Guide

**Purpose:** Step-by-step instructions for verifying the integrity of the Phase 0 disclosure bundle.

---

## Prerequisites

- **Git**: Version 2.0 or higher
- **Bash**: macOS or Linux shell
- **Hash utilities**: `shasum` (macOS) or `sha256sum` (Linux) — auto-detected by script

---

## Quick Verification

### Step 1: Clone the Repository

```bash
git clone https://github.com/drosenbluth25/vaultghost-chain-ledger.git
cd vaultghost-chain-ledger
```

### Step 2: Checkout the Phase 0 Tag (After Publication)

```bash
git checkout phase0-v1.0
```

*(Replace with actual tag name from `PUBLICATION_RECORD_TEMPLATE.md`)*

### Step 3: Generate Bundle Digest

```bash
./generate_bundle_digest.sh
```

**Expected output:**

```
Phase 0 Bundle Digest (SHA-256):
[64-character hex string]
```

### Step 4: Compare Digest

Compare the output digest with the one recorded in `PUBLICATION_RECORD_TEMPLATE.md`.

**Match?** ✅ Bundle is intact and unmodified.  
**Mismatch?** ⚠️ Bundle may have been altered — investigate further.

---

## Detailed Verification

### Verify File Completeness

Check that all files listed in `FINAL_INDEX.md` are present:

```bash
# Check for required documentation
ls -1 FINAL_INDEX.md \
      PUBLICATION_RECORD_TEMPLATE.md \
      DISCLOSURE_RATIONALE.md \
      VERIFICATION_GUIDE.md \
      PHASE0_CHECKLIST.md \
      EVIDENCE_HANDLING.md \
      DIGEST_SPECIFICATION.md

# Check for required scripts
ls -1 generate_bundle_digest.sh \
      publish_disclosure_hardened.sh
```

### Verify Script Executability

```bash
test -x generate_bundle_digest.sh && echo "✓ generate_bundle_digest.sh is executable"
test -x publish_disclosure_hardened.sh && echo "✓ publish_disclosure_hardened.sh is executable"
```

### Verify Git Commit Hash

```bash
git rev-parse HEAD
```

Compare with the commit hash in `PUBLICATION_RECORD_TEMPLATE.md`.

### Verify No Local Modifications

```bash
git status
```

Should show: `nothing to commit, working tree clean`

---

## Manual Digest Calculation

If you prefer to calculate the digest manually:

### macOS

```bash
cat FINAL_INDEX.md \
    PUBLICATION_RECORD_TEMPLATE.md \
    DISCLOSURE_RATIONALE.md \
    VERIFICATION_GUIDE.md \
    PHASE0_CHECKLIST.md \
    EVIDENCE_HANDLING.md \
    DIGEST_SPECIFICATION.md \
    generate_bundle_digest.sh \
    publish_disclosure_hardened.sh \
    | shasum -a 256
```

### Linux

```bash
cat FINAL_INDEX.md \
    PUBLICATION_RECORD_TEMPLATE.md \
    DISCLOSURE_RATIONALE.md \
    VERIFICATION_GUIDE.md \
    PHASE0_CHECKLIST.md \
    EVIDENCE_HANDLING.md \
    DIGEST_SPECIFICATION.md \
    generate_bundle_digest.sh \
    publish_disclosure_hardened.sh \
    | sha256sum
```

---

## Troubleshooting

### Digest Mismatch

**Possible causes:**

1. Files were modified after publication
2. Line ending differences (CRLF vs LF)
3. Encoding differences (non-UTF-8)
4. Missing or extra files

**Solutions:**

- Re-clone the repository from scratch
- Verify you're on the correct commit/tag
- Check file encodings: `file -I *.md *.sh`
- Check line endings: `dos2unix` or `unix2dos`

### Script Not Executable

```bash
chmod +x generate_bundle_digest.sh publish_disclosure_hardened.sh
```

### Hash Utility Not Found

**macOS:** Install Xcode Command Line Tools:

```bash
xcode-select --install
```

**Linux:** Install coreutils:

```bash
sudo apt-get install coreutils  # Debian/Ubuntu
sudo yum install coreutils      # RHEL/CentOS
```

---

## Advanced Verification

### Verify with External Timestamp

If an external timestamp (e.g., blockchain) is provided in `PUBLICATION_RECORD_TEMPLATE.md`:

1. Retrieve the timestamped hash from the blockchain
2. Compare with the locally generated digest
3. Verify the timestamp is before any claimed publication date

### Verify PGP Signature (If Provided)

```bash
gpg --verify bundle.sig PUBLICATION_RECORD_TEMPLATE.md
```

---

## Reporting Issues

If verification fails:

1. **Do not modify any files**
2. Document the exact error message
3. Open an issue: https://github.com/drosenbluth25/vaultghost-chain-ledger/issues
4. Include:
   - Operating system and version
   - Git commit hash you're verifying
   - Output of `./generate_bundle_digest.sh`
   - Output of `git status`

---

## Security Note

This verification process checks **internal consistency** (files match the published digest). It does **not** protect against:

- A malicious maintainer who publishes a fake digest
- Compromised GitHub account
- Time-of-check-time-of-use attacks

For higher assurance, use external attestation methods (blockchain timestamps, PGP signatures, third-party archives).
