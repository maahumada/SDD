# Task 032: Auto-Run /sdd-continue Through Apply and Verify

**Priority**: High  
**Status**: Completed  
**Depends on**: 008-command-contract-and-grammar.md, 009-orchestrator-core-skill.md, 010-adapter-core-router-and-sync-policy.md

---

## Objective

Make SDD workflow progression fully automatic in normal operation so users do
not need manual approval pauses or separate `/sdd-apply` and `/sdd-verify`
commands for standard completion.

## Deliverables

- Update `skills/sdd-orchestrator/SKILL.md`
- Update `docs/sdd-command-contract.md`
- Update `docs/adapters/sdd-router-core.md`
- Update adapter docs/templates and OpenCode command templates/examples

## Scope

Implemented behavior:
- Auto-approve proposal/planning/apply gates in orchestrator policy.
- Make `/sdd-continue` run dependency-ready phases in a loop until
  `completed`, `blocked`, or `failed`.
- Auto-run apply batches and verify from `/sdd-continue`.
- Keep `/sdd-apply` and `/sdd-verify` as optional targeted override commands.
- Align adapter/router/readme/template text with automatic default behavior.

## Acceptance Criteria

- [x] Orchestrator skill no longer pauses for manual gate approvals
- [x] `/sdd-continue` is documented and implemented as end-to-end auto-run
- [x] `/sdd-apply` and `/sdd-verify` are documented as optional targeted commands
- [x] Router core and command contract reflect automatic workflow behavior
- [x] Adapter templates/examples are synchronized with new default behavior
