# Task 002: Define the Proposer Sub-Agent

**Priority**: High  
**Status**: Completed  
**Depends on**: ADR-001

---

## Objective

Create the SKILL.md file for the **Proposer** sub-agent at `skills/sdd-propose/SKILL.md`.

## Role Summary

The Proposer takes exploration analysis (or direct user input) and produces a structured `proposal.md` with intent, scope, approach, risks, rollback plan, and success criteria. It is the root node of the workflow DAG -- everything else depends on the proposal.

## Reference

Based on `agent-teams-lite/skills/sdd-propose/SKILL.md` (129 lines, v2.0).

## What to Keep from Reference

- The overall structure: Purpose, What You Receive, What to Do (4 steps), Rules
- Step 1: Create Change Directory
- Step 2: Read Existing Specs
- Step 3: Write proposal.md (full template with all sections: Intent, Scope In/Out, Approach, Affected Areas, Risks with likelihood/mitigation, Rollback Plan, Dependencies, Success Criteria)
- Step 4: Return Summary
- Rules: always create proposal.md, read-then-update if exists, concise, must have rollback plan, must have success criteria, concrete file paths
- The structured return envelope contract

## What to Change

### Persistence Simplification (`.sdd/` filesystem-only)

The reference has:
```
- If mode is engram: ...
- If mode is openspec: ...
- If mode is hybrid: ...
- If mode is none: ...
```

**Replace with**: A single filesystem persistence section using the `.sdd/` directory convention:
1. Remove the "Execution and Persistence Contract" section referencing shared convention files
2. Remove all engram references (mem_save, topic_key, artifact type: proposal, retrieve explore dependency from engram)
3. Remove "Never force openspec/ creation unless user requested" -- we always use `.sdd/`
4. Replace all `openspec/` paths with `.sdd/`
5. Replace with:
   - Always persist to filesystem
   - Create `.sdd/changes/{change-name}/proposal.md`
   - Read existing project context from `.sdd/config.yaml`
   - Read existing specs from `.sdd/specs/` for understanding current behavior
   - If exploration exists, read `.sdd/changes/{change-name}/exploration.md`

### Metadata

- Change `author` to `Manuel Ahumada`
- Update version appropriately

### Context Loading

Simplify to: Read from `.sdd/` filesystem paths directly, no mode branching.

## Acceptance Criteria

- [x] File created at `skills/sdd-propose/SKILL.md`
- [x] No references to engram, hybrid, mode resolution, or "openspec" naming
- [x] Persistence is always `.sdd/` directory (filesystem)
- [x] The proposal.md template is complete (Intent, Scope, Approach, Affected Areas, Risks, Rollback Plan, Dependencies, Success Criteria)
- [x] The return summary format is preserved
- [x] Rules about rollback plan and success criteria being mandatory are preserved
- [x] YAML frontmatter with updated metadata
- [x] The structured envelope contract is preserved
