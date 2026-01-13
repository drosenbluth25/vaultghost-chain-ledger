# Phase 0 Disclosure — Evidence Handling Guidelines

**Purpose:** Define how to manage local evidence files that should not be committed to the repository.

---

## Overview

The VaultGhost Chain Ledger includes **public artifacts** (in `artifacts/`) and **local evidence** that should remain private or is too large/sensitive to publish.

This document explains how to handle local evidence files while maintaining the integrity of the public disclosure.

---

## Evidence Categories

### Public Artifacts

**Location:** `artifacts/` directory  
**Status:** Committed to git, publicly visible  
**Examples:**

- Run output logs
- Configuration snapshots
- Hash indexes

**Handling:** These files are part of the chain ledger and should be immutable once published.

### Local Evidence

**Location:** `evidence_phase0/` directory (gitignored)  
**Status:** NOT committed to git, kept locally  
**Examples:**

- Personal notes and analysis
- Intermediate work files
- Sensitive data (API keys, credentials)
- Large binary files (videos, full disk images)

**Handling:** Store in `evidence_phase0/` to keep them organized but excluded from version control.

---

## Directory Structure

```
vaultghost-chain-ledger/
├── artifacts/              # Public, committed
│   ├── run-003.json
│   ├── run-005.json
│   └── ...
├── evidence_phase0/        # Local, gitignored
│   ├── notes.md
│   ├── screenshots/
│   └── analysis/
├── FINAL_INDEX.md
└── ...
```

---

## Setting Up Local Evidence Directory

### Step 1: Create the Directory

```bash
mkdir -p evidence_phase0
```

### Step 2: Verify .gitignore

Ensure `.gitignore` contains:

```
evidence_phase0/
```

### Step 3: Test Exclusion

```bash
touch evidence_phase0/test.txt
git status
```

**Expected:** `evidence_phase0/test.txt` should NOT appear in untracked files.

---

## Best Practices

### DO

1. **Keep sensitive data local**: Never commit API keys, passwords, or personal information
2. **Document what you exclude**: Maintain a `README.md` inside `evidence_phase0/` explaining what's stored there
3. **Use consistent naming**: Follow the same naming conventions as public artifacts
4. **Back up locally**: Local evidence is not in git, so back it up separately

### DON'T

1. **Don't commit evidence_phase0/**: It's gitignored for a reason
2. **Don't reference local evidence in public docs**: Public documentation should be self-contained
3. **Don't store the only copy**: If evidence is critical, back it up outside the repo
4. **Don't mix public and private**: Keep public artifacts in `artifacts/`, local evidence in `evidence_phase0/`

---

## Sharing Local Evidence

If you need to share local evidence with collaborators:

### Option 1: Selective Publication

Move specific files from `evidence_phase0/` to `artifacts/` after review:

```bash
# Review the file
cat evidence_phase0/analysis.md

# If safe to publish, move it
git mv evidence_phase0/analysis.md artifacts/analysis.md
git commit -m "Publish analysis.md"
```

### Option 2: External Sharing

Use secure channels outside git:

- Encrypted email
- Secure file sharing (e.g., Keybase, Signal)
- Private cloud storage with access controls

### Option 3: Private Repository

Create a separate private repository for sensitive evidence:

```bash
cd evidence_phase0
git init
git remote add origin git@github.com:drosenbluth25/vaultghost-evidence-private.git
git add .
git commit -m "Initial evidence commit"
git push -u origin main
```

---

## Auditing Local Evidence

To ensure no local evidence leaks into the public repo:

### Check Gitignore

```bash
git check-ignore evidence_phase0/*
```

**Expected:** All files should be ignored.

### Check for Accidental Commits

```bash
git log --all --full-history -- evidence_phase0/
```

**Expected:** No commits found.

### Check for Sensitive Data in History

```bash
git grep -i "api.key\|password\|secret" $(git rev-list --all)
```

**Expected:** No matches (or only false positives).

---

## Recovery Scenarios

### Accidentally Committed Evidence

If you accidentally commit a file from `evidence_phase0/`:

```bash
# Remove from git but keep locally
git rm --cached evidence_phase0/leaked_file.txt
git commit -m "Remove accidentally committed evidence"

# If already pushed, rewrite history (DANGEROUS)
git filter-branch --index-filter \
  'git rm --cached --ignore-unmatch evidence_phase0/leaked_file.txt' \
  HEAD
```

**Warning:** Rewriting history breaks others' clones. Coordinate with collaborators.

### Lost Local Evidence

If you lose local evidence:

1. Check local backups (Time Machine, etc.)
2. Check if evidence was derived from public artifacts (can be regenerated)
3. Document the loss in `evidence_phase0/RECOVERY_LOG.md`

---

## Template: evidence_phase0/README.md

Create this file to document your local evidence:

```markdown
# Local Evidence — Phase 0

**Purpose:** Private working files for Phase 0 disclosure analysis.

## Contents

- `notes.md`: Personal analysis notes
- `screenshots/`: Browser screenshots during investigation
- `analysis/`: Intermediate analysis files

## Backup Status

- Last backup: [date]
- Backup location: [location]

## Sharing Policy

- Do not share without explicit permission
- If sharing is needed, redact sensitive information first
```

---

## Compliance Note

If this repository is subject to legal or regulatory requirements:

- Consult legal counsel before excluding evidence from version control
- Maintain audit logs of what is stored locally vs. publicly
- Ensure local evidence is preserved according to retention policies

---

## Questions?

For questions about evidence handling:

- **GitHub Issues**: https://github.com/drosenbluth25/vaultghost-chain-ledger/issues
- **Maintainer**: Daniel Rosenbluth (@drosenbluth25)
