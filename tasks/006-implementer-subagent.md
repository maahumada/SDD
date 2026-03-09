# Task 006: Define the Implementer Sub-Agent

**Priority**: High  
**Status**: Pending  
**Depends on**: ADR-001

---

## Objective

Create the SKILL.md file for the **Implementer** sub-agent at `skills/sdd-apply/SKILL.md`.

## Role Summary

The Implementer receives specific tasks from `tasks.md` and implements them by writing actual code. It follows the specs and design strictly, marks tasks as complete, and reports deviations. Supports both standard workflow and TDD (RED-GREEN-REFACTOR) workflow.

## Reference

Based on `agent-teams-lite/skills/sdd-apply/SKILL.md` (185 lines, v2.0).

## What to Keep from Reference

- The overall structure: Purpose, What You Receive, What to Do (4 steps), Rules
- Step 1: Read Context (specs, design, existing code, config)
- Step 2: Detect Implementation Mode (TDD detection priority chain)
- Step 2a: TDD Workflow (UNDERSTAND -> RED -> GREEN -> REFACTOR -> mark complete)
- Step 2b: Standard Workflow (read -> write -> mark complete)
- Test runner detection logic (config.yaml > package.json > pyproject.toml > Makefile > fallback)
- Step 3: Mark Tasks Complete (change `[ ]` to `[x]`)
- Step 4: Return Summary (full template: completed tasks, files changed, TDD results table, deviations, issues, remaining tasks, status)
- All rules: read specs first, follow design, match patterns, mark as you go, note deviations, don't implement unassigned tasks, load coding skills
- The structured return envelope contract

## What to Change

### Persistence Simplification (`.sdd/` filesystem-only)

The reference has:
```
- If mode is engram: ... artifact type apply-progress, mem_update for tasks
- If mode is openspec: ... update tasks.md with [x]
- If mode is hybrid: ... both
- If mode is none: ... return only
```

**Replace with**: A single filesystem persistence section using the `.sdd/` directory convention:
1. Remove the "Execution and Persistence Contract" referencing shared conventions
2. Remove all engram references (mem_update, apply-progress artifact type, observation IDs)
3. Remove mode resolution logic
4. Replace all `openspec/` paths with `.sdd/`
5. Replace with:
   - Read specs from `.sdd/changes/{change-name}/specs/`
   - Read design from `.sdd/changes/{change-name}/design.md`
   - Read tasks from `.sdd/changes/{change-name}/tasks.md`
   - Read project config from `.sdd/config.yaml` (TDD settings, test_command)
   - Update `.sdd/changes/{change-name}/tasks.md` with `[x]` marks as tasks complete

### Metadata

- Change `author` to `Manuel Ahumada`
- Update version appropriately

### Batched Execution

The orchestrator sends batches of tasks (e.g., "Phase 1, tasks 1.1-1.3"). The implementer should process its assigned batch and return progress. The orchestrator then asks the user whether to continue with the next batch. This enables human review between implementation phases.

## Acceptance Criteria

- [ ] File created at `skills/sdd-apply/SKILL.md`
- [ ] No references to engram, hybrid, mode resolution, or "openspec" naming
- [ ] Persistence is always `.sdd/` directory (filesystem)
- [ ] Both TDD and Standard workflow paths preserved
- [ ] TDD cycle preserved (UNDERSTAND -> RED -> GREEN -> REFACTOR)
- [ ] Test runner detection chain preserved
- [ ] Task marking mechanism preserved (`[ ]` -> `[x]`)
- [ ] Return summary template preserved (including TDD results table)
- [ ] Rules about reading specs first and reporting deviations preserved
- [ ] YAML frontmatter with updated metadata
- [ ] The structured envelope contract is preserved
