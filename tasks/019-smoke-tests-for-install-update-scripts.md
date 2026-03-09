# Task 019: Add Smoke Tests for Install and Update Scripts

**Priority**: Medium  
**Status**: Completed  
**Depends on**: 017-installer-script-for-adapters.md, 018-update-script-and-version-stamp.md

---

## Objective

Create smoke tests that validate installer/update behavior against fixture
projects.

## Deliverables

- `scripts/test-install-update.sh` (or equivalent)
- Test fixtures under `examples/fixtures/`

## Scope

Validate at least:
- Fresh install into empty fixture project
- Re-run install (idempotency check)
- Update path from older stamped blocks
- Behavior with existing custom content around managed blocks
- `--dry-run` output and non-modifying behavior

## Acceptance Criteria

- [x] Smoke test script exists and is runnable locally
- [x] Fixture project(s) included for deterministic checks
- [x] Idempotency is asserted
- [x] Managed-block-only updates are asserted
- [x] Dry-run mode is asserted as non-destructive
- [x] Test output clearly reports pass/fail per scenario
