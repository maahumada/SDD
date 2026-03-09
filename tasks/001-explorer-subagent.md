# Task 001: Define the Explorer Sub-Agent

**Priority**: High  
**Status**: Pending  
**Depends on**: ADR-001

---

## Objective

Create the SKILL.md file for the **Explorer** sub-agent at `skills/sdd-explore/SKILL.md`.

## Role Summary

The Explorer is the investigation sub-agent. It reads the codebase, compares approaches, identifies risks, and returns a structured analysis. It does NOT modify any code or files (except optionally creating `exploration.md` when tied to a named change).

## Reference

Based on `agent-teams-lite/skills/sdd-explore/SKILL.md` (127 lines, v2.0).

## What to Keep from Reference

- The overall structure: Purpose, What You Receive, What to Do (5 steps), Rules
- Step 1: Understand the Request
- Step 2: Investigate the Codebase (with the investigation tree)
- Step 3: Analyze Options (comparison table)
- Step 4: Optionally Save Exploration
- Step 5: Return Structured Analysis (full template)
- All rules about not modifying code, reading real code, keeping analysis concise
- The structured return envelope contract

## What to Change

### Persistence Simplification (`.sdd/` filesystem-only)

The reference has a multi-mode persistence section:
```
- If mode is engram: ...
- If mode is openspec: ...
- If mode is hybrid: ...
- If mode is none: ...
```

**Replace with**: A single filesystem persistence section using the `.sdd/` directory convention. Remove all references to engram, hybrid, mode resolution, and the OpenSpec name.

Specifically:
1. Remove the "Execution and Persistence Contract" section that references `skills/_shared/persistence-contract.md`
2. Remove all `engram` references (mem_save, mem_search, topic_key, observation IDs)
3. Remove the "Retrieving Context" subsection that has engram/openspec/none branches
4. Replace all `openspec/` paths with `.sdd/`
5. Replace with a simple "Persistence" section that says:
   - Read project context from `.sdd/config.yaml` and existing specs from `.sdd/specs/`
   - If a change name is provided, write `exploration.md` to `.sdd/changes/{change-name}/exploration.md`
   - If standalone exploration, return analysis inline only

### Metadata

- Change `author` from `gentleman-programming` to `Manuel Ahumada`
- Keep version as `2.0` or set to `1.0` (new project)
- Update the `description` trigger text to reflect our system

### Context Loading

Replace the 3-branch context loading (engram/openspec/none) with:
```
Before starting:
1. Read .sdd/config.yaml for project context
2. Read .sdd/specs/ for existing domain specifications
3. Read any existing change artifacts if continuing a change
```

## Acceptance Criteria

- [ ] File created at `skills/sdd-explore/SKILL.md`
- [ ] No references to engram, hybrid, mode resolution, or "openspec" naming
- [ ] Persistence is always `.sdd/` directory (filesystem)
- [ ] The 5-step exploration process is preserved
- [ ] The structured return template is preserved
- [ ] All rules about read-only behavior are preserved
- [ ] YAML frontmatter is present with updated metadata
- [ ] The structured envelope contract (status, executive_summary, etc.) is preserved
