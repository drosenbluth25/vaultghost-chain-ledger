# CI Workflow Instructions

**Note:** Due to GitHub App workflow permissions, the CI workflow file must be added manually through the GitHub web interface or by a user with appropriate permissions.

## Workflow File Location

`.github/workflows/phase0-verify.yml`

## Workflow Content

The workflow file is available at: `.github/workflows/phase0-verify.yml` (in this repository, but not yet pushed to remote)

To add it manually:

1. Navigate to the repository on GitHub
2. Go to `.github/workflows/` directory (create if it doesn't exist)
3. Create a new file named `phase0-verify.yml`
4. Copy the content from the local file or use the content below

## Alternative: Add via Git with User Credentials

If you have direct git access (not via GitHub App):

```bash
git add .github/workflows/phase0-verify.yml
git commit -m "Add CI workflow for Phase 0 verification"
git push origin phase0-disclosure
```

## Workflow Purpose

The CI workflow performs:
- Shellcheck validation for scripts
- Bundle digest generation dry-run
- File completeness checks
- Script executability verification
- BUNDLE_DIGEST.txt validation (if exists)

## Status

- ✅ Workflow file created locally
- ⚠️ Not pushed to remote (permission limitation)
- 📝 Can be added manually or in a follow-up PR with appropriate permissions
