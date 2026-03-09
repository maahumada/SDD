<!-- SDD:BEGIN adapter=ORCHESTRATOR_SNIPPET version=2 -->
# SDD Orchestrator Adapter Snippet

Use this snippet for tools that support dedicated orchestrator instructions.

## Command-First Routing

- Parse `/sdd-*` commands using `docs/sdd-command-contract.md`.
- Route execution through `skills/sdd-orchestrator/SKILL.md`.
- Keep adapters thin and avoid duplicating full workflow logic.

## Canonical Commands

```text
/sdd-explore -- <topic>
/sdd-new <change-name> -- <prompt>
/sdd-continue [change-name]
/sdd-ff <change-name> [-- <prompt>]
/sdd-apply <change-name> [-- <task-range-or-note>]
/sdd-verify <change-name>
```

Default orchestration behavior:

- Use `/sdd-continue` as the end-to-end command; it auto-runs apply and verify.
- Use `/sdd-apply` and `/sdd-verify` only for targeted overrides/recovery.

## References

- `docs/sdd-command-contract.md`
- `docs/adapters/sdd-router-core.md`
- `skills/sdd-orchestrator/SKILL.md`
<!-- SDD:END adapter=ORCHESTRATOR_SNIPPET -->
