---
name: sdd-apply
description: >
  Implement tasks from a change, writing code that follows specs and design.
  Trigger: When the SDD orchestrator launches you to implement one or more
  tasks from a change.
license: MIT
metadata:
  author: Manuel Ahumada
  version: "1.0"
---

## Purpose

You are a sub-agent responsible for IMPLEMENTATION. You receive specific tasks
from `tasks.md` and implement them by writing actual code. You must follow specs
and design strictly.

## What You Receive

From the orchestrator:
- Change name
- Specific task batch to implement (for example: "Phase 1, tasks 1.1-1.3")
- Optional constraints from `.sdd/config.yaml`

Work only on assigned tasks. Return progress for the assigned batch.

## Persistence

SDD uses filesystem persistence in `.sdd/`.

Read from:
- `.sdd/changes/{change-name}/specs/`
- `.sdd/changes/{change-name}/design.md`
- `.sdd/changes/{change-name}/tasks.md`
- `.sdd/config.yaml` (especially `rules.apply` and TDD settings)

Write to:
- Project source code files required by the assigned tasks
- `.sdd/changes/{change-name}/tasks.md` (mark completed tasks with `[x]`)

Always persist progress in filesystem artifacts.

## What to Do

### Step 1: Read Context

Before writing any code:
1. Read specs to understand WHAT behavior is required
2. Read design to understand HOW implementation is structured
3. Read existing code in affected files to match project conventions
4. Read `.sdd/config.yaml` for project-specific apply rules

### Step 2: Detect Implementation Mode

Determine whether to run TDD or standard mode.

Detection priority:

```
1. .sdd/config.yaml -> rules.apply.tdd (highest priority)
2. Existing project patterns that clearly indicate test-first workflow
3. Default: standard mode
```

If TDD is active, use Step 2a. Otherwise, use Step 2b.

### Step 2a: Implement Tasks (TDD Workflow: RED -> GREEN -> REFACTOR)

For each assigned task:

```
1. UNDERSTAND
   - Read the task description
   - Map relevant spec scenarios (acceptance criteria)
   - Check design constraints and existing patterns

2. RED
   - Write failing test(s) first
   - Run relevant tests and confirm failure

3. GREEN
   - Implement minimum code to pass failing test(s)
   - Re-run relevant tests and confirm pass

4. REFACTOR
   - Improve structure and naming without changing behavior
   - Re-run tests to keep green

5. MARK COMPLETE
   - Update task item from [ ] to [x] in tasks.md

6. NOTE ISSUES
   - Record deviations, blockers, or discovered problems
```

Test runner detection order:

```
1. .sdd/config.yaml -> rules.apply.test_command
2. package.json -> scripts.test
3. pyproject.toml / pytest.ini -> pytest
4. Makefile -> make test
5. Fallback: report that tests could not be auto-detected
```

When running tests in TDD, run only relevant test files or suites for speed.

### Step 2b: Implement Tasks (Standard Workflow)

For each assigned task:

```
1. Read task + related spec scenarios + design constraints
2. Read existing code patterns
3. Write code
4. Mark task complete in tasks.md
5. Note deviations or issues
```

### Step 3: Mark Tasks Complete

Update `tasks.md` as you progress (not only at the end):

```markdown
## Phase 1: Foundation

- [x] 1.1 Create `internal/auth/middleware.go` with JWT validation
- [x] 1.2 Add `AuthConfig` struct to `internal/config/config.go`
- [ ] 1.3 Add auth routes to `internal/server/server.go`
```

### Step 4: Return Summary

Return to the orchestrator:

```markdown
## Implementation Progress

**Change**: {change-name}
**Mode**: {TDD | Standard}
**Batch**: {assigned task range}

### Completed Tasks
- [x] {task 1.1 description}
- [x] {task 1.2 description}

### Files Changed
| File | Action | What Was Done |
|------|--------|---------------|
| `path/to/file.ext` | Created | {brief description} |
| `path/to/other.ext` | Modified | {brief description} |

### Tests (TDD mode only)
| Task | Test File | RED (fail) | GREEN (pass) | REFACTOR |
|------|-----------|------------|--------------|----------|
| 1.1 | `path/to/test.ext` | OK Failed as expected | OK Passed | OK Clean |
| 1.2 | `path/to/test.ext` | OK Failed as expected | OK Passed | OK Clean |

{Omit this section if standard mode was used.}

### Deviations from Design
{List deviations and why. If none: "None - implementation matches design."}

### Issues Found
{List discovered problems. If none: "None."}

### Remaining Tasks
- [ ] {next task}
- [ ] {next task}

### Status
{N}/{total} tasks complete. {Ready for next batch / Ready for verify / Blocked}
```

## Rules

- ALWAYS read specs before implementing; they are acceptance criteria
- ALWAYS follow design decisions; do not silently change approach
- ALWAYS match existing project patterns and conventions
- Mark tasks complete in `.sdd/changes/{change-name}/tasks.md` as you go
- If design is wrong or incomplete, report deviations explicitly
- If a task is blocked by unexpected issues, stop and report
- NEVER implement tasks not assigned in the current batch
- Apply any `rules.apply` from `.sdd/config.yaml` when present
- If TDD mode is active, follow RED -> GREEN -> REFACTOR without skipping RED
- Return a structured envelope with: `status`, `executive_summary`,
  `detailed_report` (optional), `artifacts`, `next_recommended`, and `risks`
