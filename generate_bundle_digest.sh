#!/usr/bin/env bash
# Phase 0 Bundle Digest Generator
# Generates SHA-256 digest of Phase 0 disclosure bundle
# Cross-platform: macOS + Linux

set -euo pipefail

# Auto-detect hash utility
if command -v shasum >/dev/null 2>&1; then
    HASH_CMD="shasum -a 256"
elif command -v sha256sum >/dev/null 2>&1; then
    HASH_CMD="sha256sum"
else
    echo "Error: Neither shasum nor sha256sum found" >&2
    echo "Please install one of these utilities:" >&2
    echo "  macOS: xcode-select --install" >&2
    echo "  Linux: sudo apt-get install coreutils" >&2
    exit 1
fi

# Check that all required files exist
REQUIRED_FILES=(
    "FINAL_INDEX.md"
    "PUBLICATION_RECORD_TEMPLATE.md"
    "DISCLOSURE_RATIONALE.md"
    "VERIFICATION_GUIDE.md"
    "PHASE0_CHECKLIST.md"
    "EVIDENCE_HANDLING.md"
    "DIGEST_SPECIFICATION.md"
    "generate_bundle_digest.sh"
    "publish_disclosure_hardened.sh"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: Required file not found: $file" >&2
        exit 1
    fi
done

# Generate digest
echo "Phase 0 Bundle Digest (SHA-256):"
cat "${REQUIRED_FILES[@]}" | $HASH_CMD | awk '{print $1}'
