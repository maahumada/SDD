# SDD Adapter (CLAUDE.md)

This repository uses SDD (Spec Driven Development) for complex work.

## Core Routing

- Parse `/sdd-*` commands using `docs/sdd-command-contract.md`.
- Route execution through `skills/sdd-orchestrator/SKILL.md`.
- Keep this adapter thin and delegate phase work to SDD sub-agents.

## Canonical Commands

```text
/sdd-explore -- <topic>
/sdd-new <change-name> -- <prompt>
/sdd-continue [change-name]
/sdd-ff <change-name> [-- <prompt>]
/sdd-apply <change-name> [-- <task-range-or-note>]
/sdd-verify <change-name>
```

Use canonical syntax in examples and correction hints.

## Command vs Plain Language

- If input starts with `/sdd-*`, follow command-first routing.
- If input is complex and non-command, suggest:
  `/sdd-new <change-name> -- <request>`
- If auto-routing is enabled, map complex request to `/sdd-new`.
- Keep proposal and planning approval gates before implementation.

## Delegation Pattern

In orchestrator mode, delegate to:
- `sdd-explore`
- `sdd-propose`
- `sdd-spec`
- `sdd-design`
- `sdd-tasks`
- `sdd-apply`
- `sdd-verify`

Do not execute phase content inline when sub-agent delegation is available.

## Fresh Context Note

When your environment supports true sub-agent execution, use fresh context per
sub-agent. If delegation is unavailable, preserve the same phase ordering and
guardrails inline.

## References

- `docs/sdd-command-contract.md`
- `docs/adapters/sdd-router-core.md`
- `docs/adapters/sync-policy.md`
- `skills/sdd-orchestrator/SKILL.md`
