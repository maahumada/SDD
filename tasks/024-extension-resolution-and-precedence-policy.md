# Task 024: Implement Extension Resolution and Precedence Policy

**Priority**: High  
**Status**: Pending  
**Depends on**: 022-extension-contract-and-manifest-schema.md, 023-extension-lifecycle-command-contract.md

---

## Objective

Define deterministic extension resolution, merge semantics, and conflict policy
for project execution.

## Deliverables

- `docs/extensions/resolution-policy.md`
- `docs/extensions/project-config-contract.md`

## Scope

Specify:
- How extensions are enabled in project config
- Deterministic resolution order
- Merge rules for skills/rules/checklists
- Conflict handling (fail/warn/override)
- Optional lock file contract (`.sdd/extensions.lock.yaml`)

Include worked examples of precedence resolution.

## Acceptance Criteria

- [ ] Resolution policy doc exists with deterministic algorithm
- [ ] Project config contract for enabling extensions is explicit
- [ ] Conflict policy is unambiguous and actionable
- [ ] Merge semantics are defined per artifact type
- [ ] Optional lock file contract is documented (or explicitly deferred)
