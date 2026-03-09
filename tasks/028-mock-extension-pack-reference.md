# Task 028: Create Mock Extension Pack Reference

**Priority**: Medium  
**Status**: Pending  
**Depends on**: 027-extension-scaffolding-tooling.md

---

## Objective

Create a non-domain-specific mock extension pack as a reference implementation
for structure, tooling, and `sdd-skillsmith` context.

## Deliverable

- `extensions/mock-governance/`

## Scope

Include:
- valid `manifest.yaml`
- one mock skill file
- one mock rules file
- one mock checklist
- README explaining that this pack is illustrative

Do not implement a real domain expert (such as REST) in this task.

## Acceptance Criteria

- [ ] Mock extension directory exists with full expected layout
- [ ] Manifest is valid according to extension schema
- [ ] Includes at least one mock skill, rules file, and checklist
- [ ] README clearly marks it as reference/demo only
- [ ] Pack can be used by docs/tests as canonical example
