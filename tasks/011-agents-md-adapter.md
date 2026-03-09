# Task 011: Add AGENTS.md Adapter

**Priority**: High  
**Status**: Completed  
**Depends on**: 010-adapter-core-router-and-sync-policy.md

---

## Objective

Create a repository-level `AGENTS.md` adapter that applies SDD philosophy for
compatible tools and routes complex work through the orchestrator behavior.

## Deliverable

Create `AGENTS.md` at repository root.

## Scope

`AGENTS.md` should include:
- Brief SDD philosophy and when to activate it
- Command usage references (`/sdd-*` canonical forms)
- Router behavior for plain-language complex requests
- Delegation requirement: use `skills/sdd-orchestrator/SKILL.md` flow
- Guardrails: no direct implementation before proposal/spec/design/tasks

## Acceptance Criteria

- [x] File created at `AGENTS.md`
- [x] `/sdd-*` command references match Task 008 grammar
- [x] Delegation to orchestrator is explicit
- [x] Guardrails against skipping phases are explicit
- [x] Content remains adapter-thin (no duplicated full orchestrator logic)
- [x] No references to `engram`, `hybrid`, or `openspec` naming
