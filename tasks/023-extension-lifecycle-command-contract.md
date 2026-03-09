# Task 023: Define Extension Lifecycle Command Contract

**Priority**: High  
**Status**: Completed  
**Depends on**: 022-extension-contract-and-manifest-schema.md

---

## Objective

Define canonical commands for extension lifecycle operations so users can manage
extensions in a predictable way.

## Deliverable

- `docs/extensions/command-contract.md`

## Scope

Define command grammar and behavior for operations such as:
- create/scaffold extension
- validate extension
- list available/enabled extensions
- enable/disable extension per project
- show extension metadata

Document:
- canonical syntax
- required/optional arguments
- error handling and correction hints
- expected output envelopes

## Acceptance Criteria

- [x] Command contract doc exists with canonical syntax
- [x] Each lifecycle command has argument and behavior definition
- [x] Validation and error behavior is explicit
- [x] Output format conventions are documented
- [x] Examples are realistic and copy-paste ready
