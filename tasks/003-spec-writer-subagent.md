# Task 003: Define the Spec-Writer Sub-Agent

**Priority**: High  
**Status**: Completed  
**Depends on**: ADR-001

---

## Objective

Create the SKILL.md file for the **Spec-Writer** sub-agent at `skills/sdd-spec/SKILL.md`.

## Role Summary

The Spec-Writer takes the proposal and produces delta specifications -- structured requirements and scenarios that describe what's being ADDED, MODIFIED, or REMOVED from the system's behavior. Uses Given/When/Then format and RFC 2119 keywords (MUST, SHALL, SHOULD, MAY).

## Reference

Based on `agent-teams-lite/skills/sdd-spec/SKILL.md` (167 lines, v2.0).

## What to Keep from Reference

- The overall structure: Purpose, What You Receive, What to Do (4 steps), Rules, RFC 2119 Quick Reference
- Step 1: Identify Affected Domains
- Step 2: Read Existing Specs
- Step 3: Write Delta Specs (full format with ADDED/MODIFIED/REMOVED sections, Given/When/Then scenarios)
- The "For NEW Specs" format (full spec, not delta, when no existing spec exists)
- Step 4: Return Summary (with domain coverage table)
- All rules about Given/When/Then, RFC 2119, delta vs full, testable scenarios, no implementation details
- The RFC 2119 Keywords Quick Reference table
- The structured return envelope contract

## What to Change

### Persistence Simplification (`.sdd/` filesystem-only)

The reference has multi-mode persistence:
```
- If mode is engram: ... concatenate into single artifact with domain headers
- If mode is openspec: ...
- If mode is hybrid: ... persist to Engram AND write domain files
- If mode is none: ...
```

**Replace with**: A single filesystem persistence section using the `.sdd/` directory convention:
1. Remove the "Execution and Persistence Contract" referencing shared conventions
2. Remove all engram references (concatenating domains into single artifact, mem_save, topic_key)
3. Remove mode resolution logic
4. Replace all `openspec/` paths with `.sdd/`
5. Replace with:
   - Read proposal from `.sdd/changes/{change-name}/proposal.md`
   - Read existing main specs from `.sdd/specs/{domain}/spec.md`
   - Write delta specs to `.sdd/changes/{change-name}/specs/{domain}/spec.md`
   - Read project config from `.sdd/config.yaml` for rules

### Metadata

- Change `author` to `Manuel Ahumada`
- Update version appropriately

### Notes

The spec-writer can run in **parallel** with the designer (both depend on the proposal). This should be noted in the skill definition.

## Acceptance Criteria

- [x] File created at `skills/sdd-spec/SKILL.md`
- [x] No references to engram, hybrid, mode resolution, or "openspec" naming
- [x] Persistence is always `.sdd/` directory (filesystem)
- [x] Delta spec format preserved (ADDED/MODIFIED/REMOVED with Given/When/Then)
- [x] Full spec format for new domains preserved
- [x] RFC 2119 keywords reference preserved
- [x] Rules about testable scenarios and no implementation details preserved
- [x] YAML frontmatter with updated metadata
- [x] The structured envelope contract is preserved
- [x] Note about parallelism with Designer is included
