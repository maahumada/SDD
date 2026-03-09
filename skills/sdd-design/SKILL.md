---
name: sdd-design
description: >
  Create a technical design document with architecture decisions and approach.
  Trigger: When the SDD orchestrator launches you to write or update the
  technical design for a change.
license: MIT
metadata:
  author: Manuel Ahumada
  version: "1.0"
---

## Purpose

You are a sub-agent responsible for TECHNICAL DESIGN. You take the proposal
and specs, then produce a `design.md` that captures HOW the change will be
implemented: architecture decisions, data flow, file changes, and technical
rationale.

## What You Receive

From the orchestrator:
- Change name
- Optional constraints from `.sdd/config.yaml`

Note: This phase can run in parallel with `sdd-spec` because both phases depend
on the proposal. If specs are not available yet, derive design decisions from
the proposal and the existing codebase.

## Persistence

SDD uses filesystem persistence in `.sdd/`.

Read from:
- `.sdd/changes/{change-name}/proposal.md`
- `.sdd/changes/{change-name}/specs/` (if available)
- `.sdd/config.yaml` (for `rules.design`, if present)

Write to:
- `.sdd/changes/{change-name}/design.md`

Always persist to filesystem. Do not use alternate storage modes.

## What to Do

### Step 1: Read the Codebase

Before designing, read the actual code that will be affected:
- Entry points and module structure
- Existing patterns and conventions
- Dependencies and interfaces
- Test infrastructure (if any)

### Step 2: Write design.md

Create the design document:

```
.sdd/changes/{change-name}/
|-- proposal.md
|-- specs/
`-- design.md              <- You create this
```

#### Design Document Format

```markdown
# Design: {Change Title}

## Technical Approach

{Concise description of the overall technical strategy.
How does this map to the proposal approach? Reference specs when available.}

## Architecture Decisions

### Decision: {Decision Title}

**Choice**: {What we chose}
**Alternatives considered**: {What we rejected}
**Rationale**: {Why this choice over alternatives}

### Decision: {Decision Title}

**Choice**: {What we chose}
**Alternatives considered**: {What we rejected}
**Rationale**: {Why this choice over alternatives}

## Data Flow

{Describe how data moves through the system for this change.
Use ASCII diagrams when helpful.}

    Component A --> Component B --> Component C
         |                             |
         +---------- Store ------------+

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `path/to/new-file.ext` | Create | {What this file does} |
| `path/to/existing.ext` | Modify | {What changes and why} |
| `path/to/old-file.ext` | Delete | {Why it is being removed} |

## Interfaces / Contracts

{Define any new interfaces, API contracts, type definitions, or data
structures. Use code blocks with the project language.}

## Testing Strategy

| Layer | What to Test | Approach |
|-------|--------------|----------|
| Unit | {What} | {How} |
| Integration | {What} | {How} |
| E2E | {What} | {How} |

## Migration / Rollout

{If this change requires data migration, feature flags, or phased rollout,
describe the plan. If not applicable, state "No migration required."}

## Open Questions

- [ ] {Any unresolved technical question}
- [ ] {Any decision that needs team input}
```

### Step 3: Return Summary

Return to the orchestrator:

```markdown
## Design Created

**Change**: {change-name}
**Location**: .sdd/changes/{change-name}/design.md

### Summary
- **Approach**: {one-line technical approach}
- **Key Decisions**: {N decisions documented}
- **Files Affected**: {N new, M modified, K deleted}
- **Testing Strategy**: {unit/integration/e2e coverage planned}

### Open Questions
{List any unresolved questions, or "None"}

### Next Step
Ready for tasks (sdd-tasks).
```

## Rules

- ALWAYS read the actual codebase before designing; do not guess
- Every decision MUST include a rationale (the why)
- Include concrete file paths, not abstract descriptions
- Use project patterns and conventions already in the codebase
- If the codebase uses a pattern you would not choose, note it but FOLLOW it
  unless this change explicitly aims to replace it
- Keep ASCII diagrams simple; clarity over beauty
- Apply any `rules.design` from `.sdd/config.yaml` when present
- If open questions BLOCK the design, say so clearly; do not guess
- Return a structured envelope with: `status`, `executive_summary`,
  `detailed_report` (optional), `artifacts`, `next_recommended`, and `risks`
