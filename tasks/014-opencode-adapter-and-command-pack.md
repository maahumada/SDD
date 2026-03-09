# Task 014: Add OpenCode Adapter and Command Pack

**Priority**: Medium  
**Status**: Completed  
**Depends on**: 009-orchestrator-core-skill.md, 010-adapter-core-router-and-sync-policy.md

---

## Objective

Add OpenCode-specific integration files so users can invoke SDD commands and
route through the orchestrator behavior in OpenCode environments.

## Deliverables

- `examples/opencode/opencode.json` (or update instructions for existing config)
- `examples/opencode/commands/sdd-*.md` command files
- `examples/opencode/sdd-orchestrator.md` adapter snippet

## Scope

Provide:
- Command files for: `sdd-explore`, `sdd-new`, `sdd-continue`, `sdd-ff`,
  `sdd-apply`, `sdd-verify`
- Canonical command usage examples with `--` separator where needed
- Agent configuration guidance to bind command calls to orchestrator behavior
- Notes for users with existing OpenCode config (merge strategy)

## Acceptance Criteria

- [x] OpenCode command files exist for all canonical SDD commands
- [x] Command files follow the same grammar as Task 008
- [x] Adapter snippet references orchestrator skill and core router docs
- [x] Setup instructions include both new setup and merge-into-existing-config
- [x] No references to `engram`, `hybrid`, or `openspec` naming
