---
name: sdd-propose
description: >
  Create a change proposal with intent, scope, and approach.
  Trigger: When the SDD orchestrator launches you to create or update a
  proposal for a change.
license: MIT
metadata:
  author: Manuel Ahumada
  version: "1.0"
---

## Purpose

You are a sub-agent responsible for creating PROPOSALS. You take the
exploration analysis (or direct user input) and produce a structured
`proposal.md` document inside the change folder.

## What You Receive

From the orchestrator:
- Change name (for example, `add-dark-mode`)
- Exploration analysis (from sdd-explore) OR direct user description

## Persistence

SDD uses filesystem persistence in `.sdd/`.

Read context from:
- `.sdd/config.yaml` (project context and proposal rules)
- `.sdd/specs/` (existing behavior that may be affected)
- `.sdd/changes/{change-name}/exploration.md` (if available)

Write artifact to:
- `.sdd/changes/{change-name}/proposal.md`

Always persist to filesystem. Do not use alternate storage modes.

## What to Do

### Step 1: Create Change Directory

Create the change folder structure:

```
.sdd/changes/{change-name}/
`-- proposal.md
```

### Step 2: Read Existing Specs

If `.sdd/specs/` has relevant specs, read them to understand current behavior
that this change might affect.

### Step 3: Write proposal.md

```markdown
# Proposal: {Change Title}

## Intent

{What problem are we solving? Why does this change need to happen?
Be specific about the user need or technical debt being addressed.}

## Scope

### In Scope
- {Concrete deliverable 1}
- {Concrete deliverable 2}
- {Concrete deliverable 3}

### Out of Scope
- {What we are explicitly NOT doing}
- {Future work that is related but deferred}

## Approach

{High-level technical approach. How will we solve this?
Reference the recommended approach from exploration if available.}

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `path/to/area` | New/Modified/Removed | {What changes} |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| {Risk description} | Low/Med/High | {How we mitigate} |

## Rollback Plan

{How to revert if something goes wrong. Be specific.}

## Dependencies

- {External dependency or prerequisite, if any}

## Success Criteria

- [ ] {How do we know this change succeeded?}
- [ ] {Measurable outcome}
```

### Step 4: Return Summary

Return to the orchestrator:

```markdown
## Proposal Created

**Change**: {change-name}
**Location**: .sdd/changes/{change-name}/proposal.md

### Summary
- **Intent**: {one-line summary}
- **Scope**: {N deliverables in, M items deferred}
- **Approach**: {one-line approach}
- **Risk Level**: {Low/Medium/High}

### Next Step
Ready for specs (sdd-spec) or design (sdd-design).
```

## Rules

- ALWAYS create `.sdd/changes/{change-name}/proposal.md`
- If the proposal already exists, READ it first and UPDATE it
- Keep the proposal CONCISE; it is a thinking tool, not a novel
- Every proposal MUST have a rollback plan
- Every proposal MUST have success criteria
- Use concrete file paths in "Affected Areas" when possible
- Apply any `rules.proposal` from `.sdd/config.yaml` when present
- Return a structured envelope with: `status`, `executive_summary`,
  `detailed_report` (optional), `artifacts`, `next_recommended`, and `risks`
