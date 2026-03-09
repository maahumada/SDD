# Task 020: Document Adapter Installation and Update Flow

**Priority**: High  
**Status**: Pending  
**Depends on**: 017-installer-script-for-adapters.md, 018-update-script-and-version-stamp.md, 019-smoke-tests-for-install-update-scripts.md

---

## Objective

Document how users install and update SDD adapters in their own repositories.

## Deliverables

- Update `README.md`
- Create `docs/adapter-installation.md`

## Scope

Documentation must include:
- Quickstart install examples
- Full flag reference for `sdd-install.sh` and `sdd-update.sh`
- Managed block policy and backup behavior
- Recommended team workflow (install, commit, update cadence)
- Troubleshooting section (conflicts, missing markers, dry-run checks)

## Acceptance Criteria

- [ ] `docs/adapter-installation.md` exists
- [ ] README links to installation/update docs
- [ ] Examples include `--project` and `--adapters` usage
- [ ] Managed block + backup behavior is clearly explained
- [ ] Troubleshooting section covers common failure modes
