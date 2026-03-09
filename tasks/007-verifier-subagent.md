# Task 007: Define the Verifier Sub-Agent

**Priority**: High  
**Status**: Completed  
**Depends on**: ADR-001

---

## Objective

Create the SKILL.md file for the **Verifier** sub-agent at `skills/sdd-verify/SKILL.md`.

## Role Summary

The Verifier is the quality gate. It validates that the implementation is complete, correct, and behaviorally compliant with the specs. It performs both static analysis AND real test execution, producing a spec compliance matrix and a final verdict (PASS / PASS WITH WARNINGS / FAIL).

## Reference

Based on `agent-teams-lite/skills/sdd-verify/SKILL.md` (281 lines, v2.0 -- the longest skill).

## What to Keep from Reference

- The overall structure: Purpose, What You Receive, What to Do (7 steps), Rules
- Step 1: Check Completeness (task count, incomplete task flags)
- Step 2: Check Correctness - Static Specs Match (search codebase for each requirement)
- Step 3: Check Coherence - Design Match (verify decisions followed)
- Step 4: Check Testing - Static (test file existence)
- Step 4b: Run Tests - Real Execution (test runner detection, capture pass/fail/skip)
- Step 4c: Build & Type Check - Real Execution
- Step 4d: Coverage Validation (if threshold configured)
- Step 5: Spec Compliance Matrix - Behavioral Validation (COMPLIANT / FAILING / UNTESTED / PARTIAL statuses)
- Step 6: Persist Verification Report
- Step 7: Return Summary (full report template: Completeness, Build & Tests, Coverage, Spec Compliance Matrix, Correctness Static, Coherence Design, Issues Found with CRITICAL/WARNING/SUGGESTION, Verdict)
- All rules: read actual source, execute tests, COMPLIANT only when test passed, compare specs first, be objective, report don't fix, severity levels
- The structured return envelope contract

## What to Change

### Persistence Simplification (`.sdd/` filesystem-only)

The reference has:
```
- If mode is engram: ... artifact type verify-report
- If mode is openspec: ... save to verify-report.md
- If mode is hybrid: ... both
- If mode is none: ... return inline only
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
   - Read tasks from `.sdd/changes/{change-name}/tasks.md`
   - Read project config from `.sdd/config.yaml` (test_command, build_command, coverage_threshold)
   - Write verification report to `.sdd/changes/{change-name}/verify-report.md`

### Step 6 Simplification

The reference Step 6 has mode branching for persisting the report. Simplify to: "Write the report to `.sdd/changes/{change-name}/verify-report.md`."

### Metadata

- Change `author` to `Manuel Ahumada`
- Update version appropriately

### Notes

This is the most complex sub-agent (281 lines in reference). The simplification of persistence actually helps here because it removes a significant amount of conditional logic, letting the verification steps (which are the valuable part) remain clear and focused.

The Verifier NEVER fixes issues -- it only reports them. The orchestrator decides whether to loop back to the Implementer for fixes or proceed to archive.

## Acceptance Criteria

- [x] File created at `skills/sdd-verify/SKILL.md`
- [x] No references to engram, hybrid, mode resolution, or "openspec" naming
- [x] Persistence is always `.sdd/` directory (filesystem)
- [x] All 7 verification steps preserved (Completeness, Correctness, Coherence, Testing Static, Tests Real, Build, Coverage, Compliance Matrix)
- [x] Spec Compliance Matrix with COMPLIANT/FAILING/UNTESTED/PARTIAL preserved
- [x] Test runner and build command detection chains preserved
- [x] Full report template preserved (all sections)
- [x] Verdict system preserved (PASS / PASS WITH WARNINGS / FAIL)
- [x] Severity levels preserved (CRITICAL / WARNING / SUGGESTION)
- [x] Rule "NEVER fix issues, only report" preserved
- [x] YAML frontmatter with updated metadata
- [x] The structured envelope contract is preserved
