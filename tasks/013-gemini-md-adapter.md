# Task 013: Add GEMINI.md Adapter

**Priority**: Medium  
**Status**: Pending  
**Depends on**: 010-adapter-core-router-and-sync-policy.md

---

## Objective

Create `GEMINI.md` instructions that apply SDD behavior for Gemini CLI while
documenting any tool-specific limitations.

## Deliverable

Create `GEMINI.md` at repository root.

## Scope

`GEMINI.md` should include:
- Canonical `/sdd-*` command references
- Router behavior for plain-language complex requests
- How to run SDD phases when true sub-agent delegation is limited
- Fallback policy: inline orchestration while preserving phase order
- References to core router docs and orchestrator skill

## Acceptance Criteria

- [ ] File created at `GEMINI.md`
- [ ] Command syntax matches Task 008 contract
- [ ] Tool limitation notes are explicit (if applicable)
- [ ] Fallback orchestration policy preserves SDD phase order
- [ ] Adapter points to core docs instead of duplicating full logic
- [ ] No references to `engram`, `hybrid`, or `openspec` naming
