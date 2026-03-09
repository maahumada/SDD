# Task 022: Define Extension Contract and Manifest Schema

**Priority**: High  
**Status**: Pending  
**Depends on**: ADR-003-extension-architecture-and-governance.md

---

## Objective

Define the canonical extension pack contract and manifest schema so new packs
can be created and validated consistently.

## Deliverables

- `docs/extensions/extension-contract.md`
- `docs/extensions/manifest-schema.yaml`

## Scope

Specify:
- Extension directory layout (`extensions/{extension-id}/...`)
- Required `manifest.yaml` fields and allowed optional fields
- Identifier and version rules
- Declared provides: skills, rules, checklists, templates
- Declared dependencies and conflicts
- Backward compatibility and schema version policy

Include at least one full manifest example.

## Acceptance Criteria

- [ ] Contract doc exists and covers layout + required files
- [ ] Manifest schema exists and is machine-parseable
- [ ] Required fields and validation rules are explicit
- [ ] Dependencies/conflicts model is documented
- [ ] At least one valid manifest example is included
