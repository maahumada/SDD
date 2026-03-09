# ADR-002: Dual Entrypoint Strategy (Commands + Auto-Router Adapters)

**Status**: Accepted  
**Date**: 2026-03-09  
**Author**: Manuel Ahumada

---

## Context

The repository now has the 7 SDD sub-agents defined. The next decision is how
users should activate and run the framework:

1. Explicit command-driven orchestration (`/sdd-*`)
2. Automatic SDD behavior via model instruction files (`AGENTS.md`, `CLAUDE.md`, etc.)

Using only one approach creates trade-offs:
- Commands-only is deterministic but less discoverable
- Auto-only is discoverable but can drift and behave differently per model

## Decision

Adopt a dual strategy:

1. **Primary path (deterministic)**: explicit `/sdd-*` commands routed through a
   canonical orchestrator contract.
2. **Secondary path (adoption)**: model-specific instruction adapters that apply
   SDD philosophy by default and route complex requests to the same orchestrator
   behavior.

## Command Contract (Canonical)

Command format:

```
/sdd-<command> [args...] [-- <free-text-prompt>]
```

Canonical examples:

```
/sdd-explore -- review current auth architecture and risks
/sdd-new add-dark-mode -- add theme toggle with system fallback
/sdd-continue add-dark-mode
/sdd-ff add-dark-mode -- generate planning artifacts quickly
/sdd-apply add-dark-mode -- 1.1-1.3
/sdd-verify add-dark-mode
```

Rules:
- `--` is the separator for free-text prompt payload
- If no `--` is provided where required, orchestrator returns a usage hint
- Legacy shorthand may be accepted for compatibility, but docs must show the
  canonical `--` form

## Architecture Decision

- Keep one **single source of truth** for orchestrator behavior
- Keep adapters thin and tool-specific (do not duplicate workflow logic)
- Keep `.sdd/` as the shared persistence layer for all entrypoints

## Consequences

Benefits:
- High reliability for explicit command users
- Better onboarding for users who do not remember commands
- Lower drift risk by centralizing orchestration logic

Costs:
- Need to maintain adapter files for multiple tools
- Need explicit sync policy so adapters stay aligned with orchestrator contract

## Follow-up Work

- Define command grammar and parser behavior in docs
- Define `sdd-orchestrator` core instructions
- Create adapters: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, OpenCode command pack
- Update README with both usage modes and canonical syntax
