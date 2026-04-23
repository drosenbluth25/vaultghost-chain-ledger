# Phase 0 Disclosure — Bundle Digest Specification

**Purpose:** Define the technical specification for generating the Phase 0 bundle digest.

---

## Overview

The **bundle digest** is a cryptographic hash that uniquely identifies the Phase 0 disclosure bundle. It enables third parties to verify that the bundle has not been modified after publication.

---

## Algorithm

**Hash Function:** SHA-256  
**Output Format:** 64-character hexadecimal string  
**Encoding:** UTF-8

---

## Input Files

The digest is computed over the following files **in auditor-friendly stable ordering** (fixed order for reproducibility):

1. `FINAL_INDEX.md`
2. `PUBLICATION_RECORD_TEMPLATE.md`
3. `DISCLOSURE_RATIONALE.md`
4. `VERIFICATION_GUIDE.md`
5. `PHASE0_CHECKLIST.md`
6. `EVIDENCE_HANDLING.md`
7. `DIGEST_SPECIFICATION.md`
8. `generate_bundle_digest.sh`
9. `publish_disclosure_hardened.sh`

**Total:** 9 files (7 documentation + 2 scripts)

---

## Computation Method

### Concatenation

All files are concatenated **in the specified order** without any separators or delimiters (deterministic verification rules given fixed inputs):

```
content_of_file1 + content_of_file2 + ... + content_of_file9
```

### Hashing

The concatenated content is then hashed using SHA-256:

```
digest = SHA256(concatenated_content)
```

---

## Implementation

### Reference Implementation

The canonical implementation is `generate_bundle_digest.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Auto-detect hash utility
if command -v shasum >/dev/null 2>&1; then
    HASH_CMD="shasum -a 256"
elif command -v sha256sum >/dev/null 2>&1; then
    HASH_CMD="sha256sum"
else
    echo "Error: Neither shasum nor sha256sum found" >&2
    exit 1
fi

# Generate digest
cat FINAL_INDEX.md \
    PUBLICATION_RECORD_TEMPLATE.md \
    DISCLOSURE_RATIONALE.md \
    VERIFICATION_GUIDE.md \
    PHASE0_CHECKLIST.md \
    EVIDENCE_HANDLING.md \
    DIGEST_SPECIFICATION.md \
    generate_bundle_digest.sh \
    publish_disclosure_hardened.sh \
    | $HASH_CMD | awk '{print $1}'
```

### Platform Compatibility

**macOS:** Uses `shasum -a 256`  
**Linux:** Uses `sha256sum`  
**Windows:** Use WSL or Git Bash with `sha256sum`

---

## Verification

To verify the digest:

1. Clone the repository at the published commit
2. Run `./generate_bundle_digest.sh`
3. Compare the output with the digest in `PUBLICATION_RECORD_TEMPLATE.md`

**Match:** Bundle is intact ✅  
**Mismatch:** Bundle has been modified ⚠️

---

## Edge Cases

### Line Endings

**Requirement:** All files must use LF (Unix) line endings, not CRLF (Windows).

**Rationale:** Different line endings produce different hashes.

**Enforcement:** CI should check line endings before publication.

### File Encoding

**Requirement:** All files must use UTF-8 encoding without BOM.

**Rationale:** Different encodings produce different hashes.

**Enforcement:** Check encoding with `file -I filename`.

### Trailing Newlines

**Requirement:** All files should end with a single newline (POSIX standard).

**Rationale:** Ensures consistent concatenation behavior.

**Enforcement:** Configure editor to add trailing newlines automatically.

### Missing Files

**Behavior:** If any file is missing, `cat` will fail with an error.

**Rationale:** Prevents partial digest computation.

**Enforcement:** Script uses `set -e` to exit on error.

---

## Security Considerations

### Collision Resistance

SHA-256 is collision-resistant, meaning it's computationally infeasible to find two different bundles with the same digest.

### Preimage Resistance

Given a digest, it's computationally infeasible to reconstruct the original bundle (though the bundle is public anyway).

### Second Preimage Resistance

Given a bundle and its digest, it's computationally infeasible to find a different bundle with the same digest.

### Limitations

The digest **does not protect against**:

- A malicious maintainer who publishes a fake digest
- Compromised GitHub account
- Time-of-check-time-of-use attacks

**Mitigation:** Use external attestation (blockchain timestamps, PGP signatures, third-party archives).

---

## Extensibility

### Adding New Files

If Phase 0 is extended with new files:

1. Update `FINAL_INDEX.md` to list the new files
2. Update `generate_bundle_digest.sh` to include the new files **in order**
3. Increment the bundle version in `PUBLICATION_RECORD_TEMPLATE.md`
4. Regenerate the digest

### Removing Files

Removing files from Phase 0 is **not recommended** as it breaks immutability. Instead:

1. Mark the file as deprecated in `FINAL_INDEX.md`
2. Keep the file in the repository but exclude it from future versions
3. Document the reason for deprecation

---

## Alternative Implementations

### Python

```python
import hashlib

files = [
    "FINAL_INDEX.md",
    "PUBLICATION_RECORD_TEMPLATE.md",
    "DISCLOSURE_RATIONALE.md",
    "VERIFICATION_GUIDE.md",
    "PHASE0_CHECKLIST.md",
    "EVIDENCE_HANDLING.md",
    "DIGEST_SPECIFICATION.md",
    "generate_bundle_digest.sh",
    "publish_disclosure_hardened.sh",
]

hasher = hashlib.sha256()
for filename in files:
    with open(filename, "rb") as f:
        hasher.update(f.read())

print(hasher.hexdigest())
```

### Node.js

```javascript
const crypto = require('crypto');
const fs = require('fs');

const files = [
    "FINAL_INDEX.md",
    "PUBLICATION_RECORD_TEMPLATE.md",
    "DISCLOSURE_RATIONALE.md",
    "VERIFICATION_GUIDE.md",
    "PHASE0_CHECKLIST.md",
    "EVIDENCE_HANDLING.md",
    "DIGEST_SPECIFICATION.md",
    "generate_bundle_digest.sh",
    "publish_disclosure_hardened.sh",
];

const hash = crypto.createHash('sha256');
files.forEach(file => {
    hash.update(fs.readFileSync(file));
});

console.log(hash.digest('hex'));
```

---

## Testing

### Test Vector

To verify your implementation, compute the digest of this minimal test bundle:

**File 1 (test1.txt):**

```
Hello
```

**File 2 (test2.txt):**

```
World
```

**Expected digest:**

```
c0535e4be2b79ffd93291305436bf889314e4a3faec05ecffcbb7df31ad9e51a
```

**Computation:**

```bash
echo -n "HelloWorld" | shasum -a 256
```

---

## Changelog

- **v1.0 (2026-01-13):** Initial specification
