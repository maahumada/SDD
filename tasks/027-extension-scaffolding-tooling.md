# Task 027: Build Extension Scaffolding Tooling

**Priority**: High  
**Status**: Pending  
**Depends on**: 022-extension-contract-and-manifest-schema.md, 026-skillsmith-subagent.md

---

## Objective

Provide a scaffold workflow that creates extension skeletons from a standard
template, reducing manual setup and drift.

## Deliverables

- `scripts/sdd-extension-new.sh`
- `templates/extensions/pack/`

## Scope

Scaffolding command should generate:
- extension directory layout
- starter `manifest.yaml`
- starter docs/rules/skills/checklists placeholders

It should support:
- target path
- extension id
- dry-run preview
- overwrite behavior with backups

## Acceptance Criteria

- [ ] Scaffold script exists and is executable
- [ ] Template pack exists and aligns with extension contract
- [ ] Script supports basic required flags and validation
- [ ] Dry-run works without file modifications
- [ ] Generated extension passes initial structure checks
