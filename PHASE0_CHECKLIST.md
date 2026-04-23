# Phase 0 Disclosure — Pre-Publication Checklist

**Purpose:** Ensure all requirements are met before publishing the Phase 0 bundle.

---

## File Completeness

- [ ] `FINAL_INDEX.md` exists and lists all 9 files
- [ ] `PUBLICATION_RECORD_TEMPLATE.md` exists
- [ ] `DISCLOSURE_RATIONALE.md` exists
- [ ] `VERIFICATION_GUIDE.md` exists
- [ ] `PHASE0_CHECKLIST.md` exists (this file)
- [ ] `EVIDENCE_HANDLING.md` exists
- [ ] `DIGEST_SPECIFICATION.md` exists
- [ ] `generate_bundle_digest.sh` exists and is executable
- [ ] `publish_disclosure_hardened.sh` exists and is executable

---

## File Quality

- [ ] All Markdown files use UTF-8 encoding
- [ ] All files use LF (Unix) line endings, not CRLF
- [ ] No trailing whitespace in Markdown files
- [ ] All code blocks are properly fenced with triple backticks
- [ ] All internal links are valid (e.g., references to other docs)
- [ ] No placeholder text remains (e.g., `[TODO]`, `[TBD]` in final version)

---

## Script Validation

- [ ] `generate_bundle_digest.sh` runs without errors on macOS
- [ ] `generate_bundle_digest.sh` runs without errors on Linux
- [ ] `generate_bundle_digest.sh` auto-detects `shasum` vs `sha256sum`
- [ ] `publish_disclosure_hardened.sh` checks for uncommitted changes
- [ ] `publish_disclosure_hardened.sh` warns if git user.name is not set
- [ ] `publish_disclosure_hardened.sh` does NOT forcibly mutate git config

---

## Git Repository

- [ ] Branch `phase0-disclosure` exists
- [ ] All Phase 0 files are committed to the branch
- [ ] No uncommitted changes remain
- [ ] `.gitignore` includes `evidence_phase0/` entry
- [ ] No `evidence_phase0/` files are tracked by git

---

## Documentation

- [ ] README.md includes "Phase 0 Quickstart" section
- [ ] README.md links to `FINAL_INDEX.md`
- [ ] README.md explains how to verify the bundle
- [ ] All documentation is clear and free of jargon (or jargon is explained)

---

## Verification

- [ ] `./generate_bundle_digest.sh` produces a 64-character hex digest
- [ ] Digest is recorded in `PUBLICATION_RECORD_TEMPLATE.md`
- [ ] Digest can be independently reproduced
- [ ] No file modifications after digest generation

---

## CI/CD

- [ ] GitHub Actions workflow passes (if applicable)
- [ ] No merge conflicts with main branch
- [ ] Branch is up-to-date with main (or intentionally divergent)

---

## Publication Readiness

- [ ] Pull request title: "Phase 0 disclosure bundle + digest tooling"
- [ ] Pull request description explains Phase 0 purpose
- [ ] Pull request is ready for review (not draft)
- [ ] Maintainer has reviewed all files one final time

---

## Post-Publication

After merging the PR:

- [ ] Tag the commit: `git tag -a phase0-v1.0 -m "Phase 0 disclosure bundle"`
- [ ] Push the tag: `git push origin phase0-v1.0`
- [ ] Update `PUBLICATION_RECORD_TEMPLATE.md` with actual commit hash and tag
- [ ] Generate final bundle digest and update publication record
- [ ] (Optional) Create external attestation (Archive.org, blockchain, etc.)

---

## Notes

- This checklist should be completed **before** opening the PR
- Any unchecked items should be addressed or documented as exceptions
- For ongoing work, create a new checklist for each bundle version
