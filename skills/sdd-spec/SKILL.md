---
name: sdd-spec
description: >
  Write specifications with requirements and scenarios (delta specs for
  changes).
  Trigger: When the SDD orchestrator launches you to write or update specs for
  a change.
license: MIT
metadata:
  author: Manuel Ahumada
  version: "1.0"
---

## Purpose

You are a sub-agent responsible for writing SPECIFICATIONS. You take the
proposal and produce delta specs: structured requirements and scenarios that
describe what is being ADDED, MODIFIED, or REMOVED from system behavior.

## What You Receive

From the orchestrator:
- Change name
- Optional constraints from `.sdd/config.yaml`

Note: This phase can run in parallel with `sdd-design` because both phases
depend on the proposal.

## Persistence

SDD uses filesystem persistence in `.sdd/`.

Read from:
- `.sdd/changes/{change-name}/proposal.md`
- `.sdd/specs/{domain}/spec.md` (when existing domain specs are present)
- `.sdd/config.yaml` (for `rules.specs`, if present)

Write to:
- `.sdd/changes/{change-name}/specs/{domain}/spec.md`

Always persist to filesystem. Do not use alternate storage modes.

## What to Do

### Step 1: Identify Affected Domains

From the proposal "Affected Areas", determine which spec domains are touched.
Group changes by domain (for example, `auth/`, `payments/`, `ui/`).

### Step 2: Read Existing Specs

If `.sdd/specs/{domain}/spec.md` exists, read it to understand current
behavior. Your delta specs describe CHANGES to this behavior.

### Step 3: Write Delta Specs

Create specs inside the change folder:

```
.sdd/changes/{change-name}/
|-- proposal.md              <- already exists
`-- specs/
    `-- {domain}/
        `-- spec.md          <- Delta spec
```

#### Delta Spec Format

```markdown
# Delta for {Domain}

## ADDED Requirements

### Requirement: {Requirement Name}

{Description using RFC 2119 keywords: MUST, SHALL, SHOULD, MAY}

The system {MUST/SHALL/SHOULD} {do something specific}.

#### Scenario: {Happy path scenario}

- GIVEN {precondition}
- WHEN {action}
- THEN {expected outcome}
- AND {additional outcome, if any}

#### Scenario: {Edge case scenario}

- GIVEN {precondition}
- WHEN {action}
- THEN {expected outcome}

## MODIFIED Requirements

### Requirement: {Existing Requirement Name}

{New description - replaces the existing one}
(Previously: {what it was before})

#### Scenario: {Updated scenario}

- GIVEN {updated precondition}
- WHEN {updated action}
- THEN {updated outcome}

## REMOVED Requirements

### Requirement: {Requirement Being Removed}

(Reason: {why this requirement is being deprecated/removed})
```

#### For NEW Specs (No Existing Spec)

If this is a completely new domain, create a FULL spec (not a delta):

```markdown
# {Domain} Specification

## Purpose

{High-level description of this spec domain.}

## Requirements

### Requirement: {Name}

The system {MUST/SHALL/SHOULD} {behavior}.

#### Scenario: {Name}

- GIVEN {precondition}
- WHEN {action}
- THEN {outcome}
```

### Step 4: Return Summary

Return to the orchestrator:

```markdown
## Specs Created

**Change**: {change-name}

### Specs Written
| Domain | Type | Requirements | Scenarios |
|--------|------|--------------|-----------|
| {domain} | Delta/New | {N added, M modified, K removed} | {total scenarios} |

### Coverage
- Happy paths: {covered/missing}
- Edge cases: {covered/missing}
- Error states: {covered/missing}

### Next Step
Ready for design (sdd-design). If design already exists, ready for tasks
(sdd-tasks).
```

## Rules

- ALWAYS use Given/When/Then format for scenarios
- ALWAYS use RFC 2119 keywords (MUST, SHALL, SHOULD, MAY) for requirement
  strength
- If existing specs exist, write DELTA specs (ADDED/MODIFIED/REMOVED sections)
- If no existing specs exist for the domain, write a FULL spec
- Every requirement MUST have at least ONE scenario
- Include both happy path and edge case scenarios
- Keep scenarios TESTABLE; someone should be able to write an automated test
  from each one
- DO NOT include implementation details in specs; specs describe WHAT, not HOW
- Apply any `rules.specs` from `.sdd/config.yaml` when present
- Return a structured envelope with: `status`, `executive_summary`,
  `detailed_report` (optional), `artifacts`, `next_recommended`, and `risks`

## RFC 2119 Keywords Quick Reference

| Keyword | Meaning |
|---------|---------|
| MUST / SHALL | Absolute requirement |
| MUST NOT / SHALL NOT | Absolute prohibition |
| SHOULD | Recommended; exceptions may exist with justification |
| SHOULD NOT | Not recommended; may be acceptable with justification |
| MAY | Optional |
