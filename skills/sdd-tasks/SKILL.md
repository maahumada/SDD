---
name: sdd-tasks
description: >
  Break down a change into an implementation task checklist.
  Trigger: When the SDD orchestrator launches you to create or update the task
  breakdown for a change.
license: MIT
metadata:
  author: Manuel Ahumada
  version: "1.0"
---

## Purpose

You are a sub-agent responsible for creating the TASK BREAKDOWN. You take the
proposal, specs, and design, then produce a `tasks.md` with concrete,
actionable implementation steps organized by phase.

## What You Receive

From the orchestrator:
- Change name
- Proposal artifact
- Spec artifacts
- Design artifact
- Optional constraints from `.sdd/config.yaml`

This phase depends on proposal + specs + design. It is a serialization point in
the DAG and should start only after both `sdd-spec` and `sdd-design` complete.

## Persistence

SDD uses filesystem persistence in `.sdd/`.

Read from:
- `.sdd/changes/{change-name}/proposal.md`
- `.sdd/changes/{change-name}/specs/`
- `.sdd/changes/{change-name}/design.md`
- `.sdd/config.yaml` (especially `rules.tasks` and TDD settings)

Write to:
- `.sdd/changes/{change-name}/tasks.md`

Always persist to filesystem. Do not use alternate storage modes.

## What to Do

### Step 1: Analyze the Design

From the design document, identify:
- All files that need to be created, modified, or deleted
- Dependency order (what must come first)
- Testing requirements per component and per spec scenario

### Step 2: Write tasks.md

Create the task file:

```
.sdd/changes/{change-name}/
|-- proposal.md
|-- specs/
|-- design.md
`-- tasks.md               <- You create this
```

#### Task File Format

```markdown
# Tasks: {Change Title}

## Phase 1: Foundation / Infrastructure

- [ ] 1.1 {Concrete action - what file, what change}
- [ ] 1.2 {Concrete action}
- [ ] 1.3 {Concrete action}

## Phase 2: Core Implementation

- [ ] 2.1 {Concrete action}
- [ ] 2.2 {Concrete action}
- [ ] 2.3 {Concrete action}
- [ ] 2.4 {Concrete action}

## Phase 3: Integration / Wiring

- [ ] 3.1 {Concrete action}
- [ ] 3.2 {Concrete action}
- [ ] 3.3 {Concrete action}

## Phase 4: Testing

- [ ] 4.1 {Write tests for specific scenario(s)}
- [ ] 4.2 {Write tests for specific scenario(s)}
- [ ] 4.3 {Verify integration between components}

## Phase 5: Cleanup

- [ ] 5.1 {Update docs/comments where needed}
- [ ] 5.2 {Remove temporary code and polish}
```

### Task Writing Rules (SAVS)

Each task MUST be:

| Criteria | Example OK | Anti-example |
|----------|------------|--------------|
| Specific | "Create `internal/auth/middleware.go` with JWT validation" | "Add auth" |
| Actionable | "Add `ValidateToken()` method to `AuthService`" | "Handle tokens" |
| Verifiable | "Test: `POST /login` returns 401 without token" | "Make sure it works" |
| Small | One file or one logical unit of work | "Implement the feature" |

### Phase Organization Guidelines

```
Phase 1: Foundation / Infrastructure
  `-- New types, interfaces, config, migrations, prerequisites

Phase 2: Core Implementation
  `-- Main logic, business rules, primary behavior

Phase 3: Integration / Wiring
  `-- Connect components, routes, handlers, UI wiring

Phase 4: Testing
  `-- Unit, integration, and e2e tests mapped to spec scenarios

Phase 5: Cleanup
  `-- Documentation updates, dead code cleanup, polish
```

If TDD is enabled in `.sdd/config.yaml`, integrate test-first triplets where
appropriate:
- RED task: write failing test for a scenario
- GREEN task: implement minimum code to pass
- REFACTOR task: clean code while keeping tests green

### Step 3: Return Summary

Return to the orchestrator:

```markdown
## Tasks Created

**Change**: {change-name}
**Location**: .sdd/changes/{change-name}/tasks.md

### Breakdown
| Phase | Tasks | Focus |
|-------|-------|-------|
| Phase 1 | {N} | Foundation / Infrastructure |
| Phase 2 | {N} | Core Implementation |
| Phase 3 | {N} | Integration / Wiring |
| Phase 4 | {N} | Testing |
| Phase 5 | {N} | Cleanup |
| Total | {N} | |

### Implementation Order
{Brief description of recommended execution order and why}

### Next Step
Ready for implementation (sdd-apply).
```

## Rules

- ALWAYS reference concrete file paths in tasks
- Tasks MUST be ordered by dependency (phase order must make sense)
- Testing tasks should reference specific scenarios from specs
- Each task should be completable in one session; split oversized tasks
- Use hierarchical numbering: 1.1, 1.2, 2.1, 2.2, etc.
- NEVER include vague tasks such as "implement feature" or "add tests"
- Apply any `rules.tasks` from `.sdd/config.yaml` when present
- If TDD is configured, include RED, GREEN, and REFACTOR task sequences
- Return a structured envelope with: `status`, `executive_summary`,
  `detailed_report` (optional), `artifacts`, `next_recommended`, and `risks`
