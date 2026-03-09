# Task 029: Add Extension Validation and Linting

**Priority**: High  
**Status**: Pending  
**Depends on**: 022-extension-contract-and-manifest-schema.md, 028-mock-extension-pack-reference.md

---

## Objective

Add validation tooling so extension packs can be checked for schema compliance,
layout correctness, and internal consistency.

## Deliverables

- `scripts/sdd-extension-validate.sh`
- Validation docs in `docs/extensions/validation.md`

## Scope

Validator should check:
- manifest schema validity
- required files and directories
- referenced file existence
- dependency and conflict declarations
- duplicate or invalid extension identifiers

Support validation for:
- single extension path
- all extensions in repository

## Acceptance Criteria

- [ ] Validation script exists and is executable
- [ ] Schema and layout checks are implemented
- [ ] Script returns non-zero exit code on validation failure
- [ ] Supports single-extension and full-repo validation modes
- [ ] Validation docs include examples and common failures
