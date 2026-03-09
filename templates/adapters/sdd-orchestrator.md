<!-- SDD:BEGIN adapter=ORCHESTRATOR_SNIPPET version=1 -->
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

## References

- `docs/sdd-command-contract.md`
- `docs/adapters/sdd-router-core.md`
- `skills/sdd-orchestrator/SKILL.md`
<!-- SDD:END adapter=ORCHESTRATOR_SNIPPET -->
