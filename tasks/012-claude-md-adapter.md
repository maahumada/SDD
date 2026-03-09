# Task 012: Add CLAUDE.md Adapter

**Priority**: High  
**Status**: Completed  
**Depends on**: 010-adapter-core-router-and-sync-policy.md

---

## Objective

Create `CLAUDE.md` instructions that integrate SDD workflow behavior for Claude
Code while preserving the same command contract and orchestration policy.

## Deliverable

Create `CLAUDE.md` at repository root.

## Scope

`CLAUDE.md` should include:
- SDD activation logic for command and non-command requests
- Canonical command syntax with examples
- Expected delegation pattern to `skills/sdd-orchestrator/SKILL.md`
- Notes about sub-agent execution with fresh context when tooling supports it
- Minimal, adapter-style content (reference core docs instead of duplicating)

## Acceptance Criteria

- [x] File created at `CLAUDE.md`
- [x] Command examples use canonical `--` separator where needed
- [x] Behavior is aligned with `docs/adapters/sdd-router-core.md`
- [x] Orchestrator reference path is explicit
- [x] Adapter remains concise and non-duplicative
- [x] No references to `engram`, `hybrid`, or `openspec` naming
