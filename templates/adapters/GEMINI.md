<!-- SDD:BEGIN adapter=GEMINI version=3 -->
# SDD Adapter (GEMINI.md)

This repository uses SDD (Spec Driven Development) for complex feature work.

## Core Routing

- Parse `/sdd-*` commands using `docs/sdd-command-contract.md`.
- Route workflow through `skills/sdd-orchestrator/SKILL.md`.
- Keep this adapter concise and reference core docs.
- Treat `/sdd-continue` as the default end-to-end command (auto-runs apply and verify).

## Canonical Commands

```text
/sdd-explore -- <topic>
/sdd-new <change-name> -- <prompt>
/sdd-continue [change-name]
/sdd-ff <change-name> [-- <prompt>]
/sdd-apply <change-name> [-- <task-range-or-note>]
/sdd-verify <change-name>
```

## Plain-Language Fallback

If request is complex and not a command:
- Suggest `/sdd-new <change-name> -- <request>`.
- If auto-routing is enabled, map it to `/sdd-new`.
- Keep phase order and automatic gate progression from orchestrator policy.

## Delegation and Tool Limitations

Prefer true sub-agent delegation when your Gemini environment supports it.
If not supported, run orchestrator logic inline while preserving:
- command contract
- workflow DAG order
- automatic proposal/planning/apply/verify gate transitions

Inline fallback must still follow `skills/sdd-orchestrator/SKILL.md` behavior.

## References

- `docs/sdd-command-contract.md`
- `docs/adapters/sdd-router-core.md`
- `docs/adapters/sync-policy.md`
- `skills/sdd-orchestrator/SKILL.md`
<!-- SDD:END adapter=GEMINI -->
