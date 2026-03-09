# Task 004: Define the Designer Sub-Agent

**Priority**: High  
**Status**: Pending  
**Depends on**: ADR-001

---

## Objective

Create the SKILL.md file for the **Designer** sub-agent at `skills/sdd-design/SKILL.md`.

## Role Summary

The Designer takes the proposal (and specs, if available) and produces a `design.md` that captures HOW the change will be implemented -- architecture decisions with rationale, data flow, file changes, interfaces/contracts, testing strategy, and migration plan.

## Reference

Based on `agent-teams-lite/skills/sdd-design/SKILL.md` (150 lines, v2.0).

## What to Keep from Reference

- The overall structure: Purpose, What You Receive, What to Do (3 steps), Rules
- Step 1: Read the Codebase (entry points, patterns, dependencies, test infra)
- Step 2: Write design.md (full template: Technical Approach, Architecture Decisions with choice/alternatives/rationale, Data Flow with ASCII diagrams, File Changes table, Interfaces/Contracts, Testing Strategy table, Migration/Rollout, Open Questions)
- Step 3: Return Summary
- All rules: read real code, every decision needs rationale, concrete file paths, follow existing patterns, clarity over beauty in diagrams, report blocking questions
- The structured return envelope contract

## What to Change

### Persistence Simplification (`.sdd/` filesystem-only)

The reference has:
```
- If mode is engram: ... retrieve proposal and spec from engram
- If mode is openspec: ...
- If mode is hybrid: ...
- If mode is none: ...
```

**Replace with**: A single filesystem persistence section using the `.sdd/` directory convention:
1. Remove the "Execution and Persistence Contract" referencing shared conventions
2. Remove all engram references
3. Remove mode resolution logic
4. Replace all `openspec/` paths with `.sdd/`
5. Replace with:
   - Read proposal from `.sdd/changes/{change-name}/proposal.md`
   - Read specs from `.sdd/changes/{change-name}/specs/` (if they exist -- may be running in parallel with spec-writer)
   - Read project config from `.sdd/config.yaml`
   - Write design to `.sdd/changes/{change-name}/design.md`

### Metadata

- Change `author` to `Manuel Ahumada`
- Update version appropriately

### Notes

The designer can run in **parallel** with the spec-writer (both depend on proposal only). If specs aren't available yet (parallel execution), the designer should derive design decisions from the proposal directly. This should be noted.

## Acceptance Criteria

- [ ] File created at `skills/sdd-design/SKILL.md`
- [ ] No references to engram, hybrid, mode resolution, or "openspec" naming
- [ ] Persistence is always `.sdd/` directory (filesystem)
- [ ] Full design.md template preserved (Technical Approach, Architecture Decisions, Data Flow, File Changes, Interfaces, Testing Strategy, Migration, Open Questions)
- [ ] Architecture Decision format preserved (Choice, Alternatives, Rationale)
- [ ] Rules about reading real code and following existing patterns preserved
- [ ] YAML frontmatter with updated metadata
- [ ] The structured envelope contract is preserved
- [ ] Note about parallelism with Spec-Writer is included
