# SDD Router Core

Version: 2  
Status: Active

This document defines the adapter routing policy for SDD entrypoints.
It is the shared behavior contract for `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`,
and OpenCode command adapters.

## Purpose

Provide one adapter-level routing policy so tool-specific instruction files stay
aligned while preserving command determinism.

## Source References

Adapters must follow these documents in this order:

1. `docs/sdd-command-contract.md` (command grammar and validation)
2. `skills/sdd-orchestrator/SKILL.md` (orchestration policy and DAG)
3. `docs/adapters/sdd-router-core.md` (this adapter routing policy)

If guidance conflicts, higher-priority source wins.

## Command-First Routing

If input starts with `/sdd-`, route by command contract immediately.

Routing rules:
- Parse command according to `docs/sdd-command-contract.md`.
- Validate args and prompt payload requirements.
- On validation failure, return usage hint with canonical syntax.
- On success, execute orchestrator flow from
  `skills/sdd-orchestrator/SKILL.md`.
- Treat `/sdd-continue` as end-to-end auto-advance (including apply and verify)
  unless blocked or failed.

Command mode always has priority over heuristic mode.

## Heuristic Activation (Plain-Language Inputs)

If user input does not start with `/sdd-`, evaluate whether SDD should be
suggested or entered.

### Signals that favor SDD activation

Activate or strongly suggest SDD when one or more apply:
- Multi-step feature request with planning and implementation.
- Cross-cutting changes across multiple modules or layers.
- Requirement-sensitive changes (auth, billing, migrations, compliance).
- User asks for architecture, spec, or phased plan.
- User asks for review gates, traceability, or verification evidence.

### Signals that favor direct execution without SDD

Do not force SDD for:
- Tiny edits in one file with clear scope.
- Formatting-only or comment-only updates.
- Simple explanatory requests with no code changes.

## Plain-Language Fallback Behavior

When input is complex but non-command:

1. Recommend canonical SDD entry command.
2. If adapter policy allows auto-entry, map request to `/sdd-new` with a
   generated `change-name` and keep original request as prompt payload.
3. Follow orchestrator checkpoints and automatic gate transitions.

Suggested message format:

```text
This request is complex and is a good fit for SDD.
Recommended command:
/sdd-new <change-name> -- <your request>
```

## Orchestration Policy References

Adapters must route phase execution through the orchestrator flow defined in:

- `skills/sdd-orchestrator/SKILL.md`

Key rules adapters must preserve:
- Orchestrator delegates phase work to sub-agents.
- Orchestrator does not perform phase content directly.
- DAG dependencies and automatic gate transitions are enforced.
- Normal completion path does not require separate `/sdd-apply` and
  `/sdd-verify` commands.

## Compatibility with Command Grammar

Adapters may support compatibility parsing for shorthand commands, but must:
- Prefer canonical syntax in examples and hints.
- Return canonical correction hints when shorthand is used.
- Keep behavior aligned with `docs/sdd-command-contract.md`.

## Conformance Checklist for Adapters

Every adapter file must satisfy all items:

- Uses command-first routing.
- Uses canonical `/sdd-*` syntax in examples.
- References orchestrator skill instead of re-implementing workflow logic.
- Preserves automatic proposal/planning/apply/verify gate progression.
- Preserves `/sdd-continue` full auto-run behavior to completion/blocked.
- Does not define contradictory parsing rules.
