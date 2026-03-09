# Task 008: Define Command Contract and Grammar

**Priority**: High  
**Status**: Completed  
**Depends on**: ADR-001, ADR-002

---

## Objective

Define the canonical SDD command grammar and parsing rules for command-driven
orchestration.

## Deliverable

Create `docs/sdd-command-contract.md`.

## Scope

Specify:
- Canonical syntax: `/sdd-<command> [args] [-- <prompt>]`
- Required and optional args for each command
- Validation rules and user-facing error messages
- Examples for all commands

Required command definitions:
- `/sdd-explore -- <topic>`
- `/sdd-new <change-name> -- <prompt>`
- `/sdd-continue [change-name]`
- `/sdd-ff <change-name> [-- <prompt>]`
- `/sdd-apply <change-name> [-- <task-range-or-note>]`
- `/sdd-verify <change-name>`

## Notes

- Use `--` as canonical separator for free-text prompts
- Document compatibility policy for non-canonical input (if supported)
- Keep examples aligned with `.sdd/` persistence and existing 7 sub-agents

## Acceptance Criteria

- [x] File created at `docs/sdd-command-contract.md`
- [x] Canonical grammar includes the `--` separator pattern
- [x] Each `/sdd-*` command has required/optional argument table
- [x] Validation and error behavior is explicitly documented
- [x] At least one realistic usage example per command is included
- [x] No references to `engram`, `hybrid`, or `openspec` naming
