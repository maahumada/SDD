# Task 005: Define the Task-Planner Sub-Agent

**Priority**: High  
**Status**: Pending  
**Depends on**: ADR-001

---

## Objective

Create the SKILL.md file for the **Task-Planner** sub-agent at `skills/sdd-tasks/SKILL.md`.

## Role Summary

The Task-Planner takes the proposal, specs, and design, then produces a `tasks.md` with concrete, actionable implementation steps organized by phase. Each task must be specific, actionable, verifiable, and small (the SAVS criteria).

## Reference

Based on `agent-teams-lite/skills/sdd-tasks/SKILL.md` (151 lines, v2.0).

## What to Keep from Reference

- The overall structure: Purpose, What You Receive, What to Do (3 steps), Rules
- Step 1: Analyze the Design (files, dependency order, testing requirements)
- Step 2: Write tasks.md (full template with phased structure: Phase 1 Foundation, Phase 2 Core, Phase 3 Integration, Phase 4 Testing, Phase 5 Cleanup)
- The SAVS criteria table (Specific, Actionable, Verifiable, Small) with examples and anti-examples
- Phase Organization Guidelines tree
- Step 3: Return Summary (phase breakdown table + implementation order)
- All rules: concrete file paths, dependency order, testing references to specs, hierarchical numbering, no vague tasks
- TDD integration note (RED/GREEN/REFACTOR task sequences when TDD is configured)
- The structured return envelope contract

## What to Change

### Persistence Simplification (`.sdd/` filesystem-only)

The reference has:
```
- If mode is engram: ... retrieve proposal, spec, design from engram
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
   - Read specs from `.sdd/changes/{change-name}/specs/`
   - Read design from `.sdd/changes/{change-name}/design.md`
   - Read project config from `.sdd/config.yaml` (especially TDD settings)
   - Write tasks to `.sdd/changes/{change-name}/tasks.md`

### Metadata

- Change `author` to `Manuel Ahumada`
- Update version appropriately

### Dependencies

This sub-agent requires ALL three prior artifacts (proposal + specs + design). It cannot run until both the spec-writer and designer have completed their work. This is a serialization point in the DAG.

## Acceptance Criteria

- [ ] File created at `skills/sdd-tasks/SKILL.md`
- [ ] No references to engram, hybrid, mode resolution, or "openspec" naming
- [ ] Persistence is always `.sdd/` directory (filesystem)
- [ ] Phased task structure template preserved (Foundation, Core, Integration, Testing, Cleanup)
- [ ] SAVS criteria table preserved
- [ ] Hierarchical numbering format preserved (1.1, 1.2, 2.1...)
- [ ] TDD integration note preserved (RED/GREEN/REFACTOR sequences)
- [ ] Rules about concrete file paths and dependency ordering preserved
- [ ] YAML frontmatter with updated metadata
- [ ] The structured envelope contract is preserved
