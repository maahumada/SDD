# Task 025: Add Orchestrator Extension Hooks

**Priority**: High  
**Status**: Pending  
**Depends on**: 024-extension-resolution-and-precedence-policy.md

---

## Objective

Integrate extension-aware hooks into orchestrator routing so phase execution can
consume extension rules and specialized skills consistently.

## Deliverables

- Update `skills/sdd-orchestrator/SKILL.md`
- `docs/extensions/orchestrator-hooks.md`

## Scope

Define:
- Which phases support extension hooks
- Pre-phase and post-phase hook points
- How resolved extension context is injected into sub-agent prompts
- Failure handling and fallback policy
- Audit traces in `.sdd/changes/{change-name}/state.yaml`

## Acceptance Criteria

- [ ] Orchestrator skill includes extension hook flow
- [ ] Hook points are documented per phase
- [ ] Injection strategy is deterministic and concise
- [ ] Failure/fallback behavior is explicitly defined
- [ ] State tracking impact is documented
