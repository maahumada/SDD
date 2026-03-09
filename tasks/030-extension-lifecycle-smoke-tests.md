# Task 030: Add Extension Lifecycle Smoke Tests

**Priority**: Medium  
**Status**: Pending  
**Depends on**: 027-extension-scaffolding-tooling.md, 029-extension-validation-and-linting.md

---

## Objective

Create smoke tests that verify extension lifecycle workflows end-to-end.

## Deliverables

- `scripts/test-extension-lifecycle.sh`
- Fixtures under `examples/fixtures/extensions/`

## Scope

Cover at least:
- scaffold new extension
- validate extension schema/layout
- apply resolution order checks on multiple enabled extensions
- ensure deterministic outcomes across re-runs

## Acceptance Criteria

- [ ] Smoke test script exists and is runnable locally
- [ ] Fixture set exists for deterministic test scenarios
- [ ] Scaffold and validation flows are exercised
- [ ] Resolution/precedence behavior is asserted
- [ ] Test output clearly reports pass/fail per scenario
