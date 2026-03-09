# Task 010: Create Adapter Core Router and Sync Policy

**Priority**: High  
**Status**: Completed  
**Depends on**: 009-orchestrator-core-skill.md

---

## Objective

Create a single source of truth for model adapters so `AGENTS.md`, `CLAUDE.md`,
`GEMINI.md`, and OpenCode command files stay aligned.

## Deliverables

- `docs/adapters/sdd-router-core.md`
- `docs/adapters/sync-policy.md`

## Scope

`sdd-router-core.md` should define:
- SDD activation heuristics (when to suggest or enter SDD)
- Command-first behavior (`/sdd-*` has priority)
- Fallback behavior for plain-language requests
- Short orchestration policy references to `skills/sdd-orchestrator/SKILL.md`

`sync-policy.md` should define:
- Which files are adapters vs source of truth
- How to update adapters when command contract changes
- Versioning notes and review checklist

## Acceptance Criteria

- [x] `docs/adapters/sdd-router-core.md` created
- [x] `docs/adapters/sync-policy.md` created
- [x] Source-of-truth hierarchy is explicit
- [x] Adapter update process is explicit and actionable
- [x] Router behavior is compatible with command grammar from Task 008
- [x] No references to `engram`, `hybrid`, or `openspec` naming
