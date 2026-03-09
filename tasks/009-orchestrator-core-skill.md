# Task 009: Define Orchestrator Core Skill

**Priority**: High  
**Status**: Completed  
**Depends on**: 008-command-contract-and-grammar.md

---

## Objective

Create the orchestrator definition that routes `/sdd-*` commands, coordinates
sub-agents, and manages DAG state.

## Deliverable

Create `skills/sdd-orchestrator/SKILL.md`.

## Scope

The orchestrator skill must define:
- Command parsing based on Task 008 contract
- Dependency-aware phase routing
- Required sub-agent invocations for each phase
- State tracking in `.sdd/changes/{change-name}/state.yaml`
- Human approval points between major phases
- Structured response envelope for orchestrator outputs

## Required Behavior

- Orchestrator never performs phase work directly
- Orchestrator delegates to existing sub-agents only:
  - `sdd-explore`
  - `sdd-propose`
  - `sdd-spec`
  - `sdd-design`
  - `sdd-tasks`
  - `sdd-apply`
  - `sdd-verify`
- `sdd-spec` and `sdd-design` can run in parallel
- `sdd-tasks` waits for both `sdd-spec` and `sdd-design`

## Acceptance Criteria

- [x] File created at `skills/sdd-orchestrator/SKILL.md`
- [x] Command routing reflects Task 008 contract
- [x] Workflow DAG and phase dependencies are explicit
- [x] `.sdd/changes/{change-name}/state.yaml` contract is defined
- [x] Human review checkpoints are documented
- [x] Rule "orchestrator delegates, never performs phase work" is explicit
- [x] No references to `engram`, `hybrid`, or `openspec` naming
