#!/usr/bin/env bash
# Phase 0 Disclosure Publication Script (Hardened)
# Performs safety checks before publishing Phase 0 bundle
# Does NOT forcibly mutate git config - only checks and warns

set -euo pipefail

echo "=== Phase 0 Disclosure Publication - Safety Checks ==="
echo

# Check 1: Git repository
if [[ ! -d .git ]]; then
    echo "❌ Error: Not in a git repository" >&2
    exit 1
fi
echo "✓ Git repository detected"

# Check 2: Uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    echo "⚠️  Warning: Uncommitted changes detected" >&2
    echo "   Run 'git status' to see changes" >&2
    echo "   Commit or stash changes before publishing" >&2
    exit 1
fi
echo "✓ No uncommitted changes"

# Check 3: Git user configuration (check only, do not mutate)
GIT_USER_NAME=$(git config user.name || echo "")
GIT_USER_EMAIL=$(git config user.email || echo "")

if [[ -z "$GIT_USER_NAME" ]]; then
    echo "⚠️  Warning: git user.name is not set" >&2
    echo "   Set it with: git config user.name 'Your Name'" >&2
    echo "   Or globally: git config --global user.name 'Your Name'" >&2
fi

if [[ -z "$GIT_USER_EMAIL" ]]; then
    echo "⚠️  Warning: git user.email is not set" >&2
    echo "   Set it with: git config user.email 'your@email.com'" >&2
    echo "   Or globally: git config --global user.email 'your@email.com'" >&2
fi

if [[ -n "$GIT_USER_NAME" && -n "$GIT_USER_EMAIL" ]]; then
    echo "✓ Git user configured: $GIT_USER_NAME <$GIT_USER_EMAIL>"
fi

# Check 4: Required files exist
echo
echo "Checking required files..."
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

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        MISSING_FILES+=("$file")
    fi
done

if [[ ${#MISSING_FILES[@]} -gt 0 ]]; then
    echo "❌ Error: Missing required files:" >&2
    for file in "${MISSING_FILES[@]}"; do
        echo "   - $file" >&2
    done
    exit 1
fi
echo "✓ All required files present"

# Check 5: Scripts are executable
echo
echo "Checking script permissions..."
if [[ ! -x generate_bundle_digest.sh ]]; then
    echo "⚠️  Warning: generate_bundle_digest.sh is not executable" >&2
    echo "   Run: chmod +x generate_bundle_digest.sh" >&2
fi

if [[ ! -x publish_disclosure_hardened.sh ]]; then
    echo "⚠️  Warning: publish_disclosure_hardened.sh is not executable" >&2
    echo "   Run: chmod +x publish_disclosure_hardened.sh" >&2
fi

if [[ -x generate_bundle_digest.sh && -x publish_disclosure_hardened.sh ]]; then
    echo "✓ Scripts are executable"
fi

# Check 6: .gitignore contains evidence_phase0/
echo
echo "Checking .gitignore..."
if [[ -f .gitignore ]]; then
    if grep -q "evidence_phase0/" .gitignore; then
        echo "✓ .gitignore contains evidence_phase0/"
    else
        echo "⚠️  Warning: .gitignore does not contain evidence_phase0/" >&2
        echo "   Add it with: echo 'evidence_phase0/' >> .gitignore" >&2
    fi
else
    echo "⚠️  Warning: .gitignore not found" >&2
    echo "   Create it with: echo 'evidence_phase0/' > .gitignore" >&2
fi

# Check 7: No evidence_phase0/ files tracked by git
echo
echo "Checking for tracked evidence files..."
if git ls-files | grep -q "^evidence_phase0/"; then
    echo "❌ Error: evidence_phase0/ files are tracked by git" >&2
    echo "   Remove them with: git rm -r --cached evidence_phase0/" >&2
    exit 1
fi
echo "✓ No evidence_phase0/ files tracked"

# Check 8: Generate bundle digest
echo
echo "Generating bundle digest..."
if [[ -x generate_bundle_digest.sh ]]; then
    DIGEST=$(./generate_bundle_digest.sh | tail -n 1)
    echo "✓ Bundle digest generated:"
    echo "  $DIGEST"
else
    echo "⚠️  Warning: Cannot generate digest (script not executable)" >&2
fi

# Summary
echo
echo "=== Pre-Publication Checks Complete ==="
echo
echo "Next steps:"
echo "1. Review all files one final time"
echo "2. Update PUBLICATION_RECORD_TEMPLATE.md with the digest above"
echo "3. Commit any final changes"
echo "4. Push to GitHub: git push origin phase0-disclosure"
echo "5. Open PR: gh pr create --title 'Phase 0 disclosure bundle + digest tooling'"
echo
