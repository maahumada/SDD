# ADR-003: Extension Architecture and Governance

**Status**: Accepted  
**Date**: 2026-03-09  
**Author**: Manuel Ahumada

---

## Context

SDD core workflow is stable and reusable, but real projects need domain-specific
rules, skills, and verification checklists (for example, strict REST APIs,
security-heavy workflows, event-driven systems, etc.).

If every project customizes core files directly, we get drift, inconsistent
behavior, and difficult upgrades.

## Decision

Adopt a first-class extension model for SDD.

Extensions are self-contained packs with skills, rules, and checklists that can
be enabled per project without changing core SDD behavior.

## Extension Pack Contract

Each extension lives under:

```text
extensions/{extension-id}/
```

Expected structure:

```text
extensions/{extension-id}/
├── manifest.yaml
├── README.md
├── skills/
├── rules/
├── checklists/
└── templates/
```

## Core Principles

1. Core SDD remains stable and tool-agnostic.
2. Project-specific logic goes into extensions or project overrides.
3. Extension behavior is deterministic via explicit enablement and precedence.
4. Extension lifecycle is standardized with scaffolding, validation, and docs.

## Resolution and Precedence

Planned precedence model:

1. Project-local overrides (highest)
2. Enabled extensions (deterministic order)
3. Core defaults (lowest)

Hard conflicts should fail fast with actionable errors.

## Authoring and Governance

Two mechanisms define consistency:

1. `sdd-skillsmith` sub-agent for creating extension packs with uniform quality
2. Extension schema, validation tooling, and smoke tests

## Mock Extension Policy

Include one mock extension pack as reference for structure and lifecycle
documentation. This gives `sdd-skillsmith` and human maintainers a concrete
baseline without coupling to a specific domain such as REST.

## Consequences

Benefits:
- Reusable domain capabilities across projects
- Cleaner core with lower drift risk
- More predictable extension quality and onboarding

Costs:
- Additional docs and tooling to maintain
- Need for clear conflict policy and versioning

## Follow-up Work

- Define extension schema and command contract
- Add orchestrator extension hooks
- Add `sdd-skillsmith` sub-agent
- Add extension scaffolding and validation scripts
- Add mock extension pack and lifecycle tests
- Document authoring and consumption end-to-end
