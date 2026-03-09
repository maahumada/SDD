# SDD Adapter (AGENTS.md)

This repository uses SDD (Spec Driven Development) for complex work.

## Core Principle

Command-first orchestration with delegated phase execution:

- Parse `/sdd-*` commands using `docs/sdd-command-contract.md`.
- Route workflow through `skills/sdd-orchestrator/SKILL.md`.
- Orchestrator coordinates; sub-agents execute phase work.
- Use `/sdd-continue` as the default end-to-end command; avoid requiring
  separate `/sdd-apply` and `/sdd-verify` in normal workflow completion.

## Canonical Commands

Use canonical syntax:

```text
/sdd-explore -- <topic>
/sdd-new <change-name> -- <prompt>
/sdd-continue [change-name]
/sdd-ff <change-name> [-- <prompt>]
/sdd-apply <change-name> [-- <task-range-or-note>]
/sdd-verify <change-name>
```

If non-canonical shorthand is accepted, return canonical correction hints.

## Plain-Language Routing

If user input is complex and does not start with `/sdd-*`, suggest SDD:

- Recommend `/sdd-new <change-name> -- <request>`.
- If auto-routing is enabled, map to `/sdd-new` and preserve request text.
- Keep orchestrator gate progression automatic (no manual approval pauses).

Use direct non-SDD handling only for trivial, low-risk, single-file tasks.

## Delegation Requirement

Follow `skills/sdd-orchestrator/SKILL.md` and delegate to these sub-agents:

- `sdd-explore`
- `sdd-propose`
- `sdd-spec`
- `sdd-design`
- `sdd-tasks`
- `sdd-apply`
- `sdd-verify`

Do not perform phase content directly in orchestrator mode.

## Guardrails

- Do not skip proposal/spec/design/tasks for complex feature work.
- Do not start implementation before planning artifacts are complete.
- Enforce DAG dependencies from `skills/sdd-orchestrator/SKILL.md`.
- Keep `/sdd-continue` auto-run behavior through apply and verify.
- Keep adapter guidance thin; do not duplicate full orchestrator logic here.

## References

- `docs/sdd-command-contract.md`
- `docs/adapters/sdd-router-core.md`
- `docs/adapters/sync-policy.md`
- `skills/sdd-orchestrator/SKILL.md`
