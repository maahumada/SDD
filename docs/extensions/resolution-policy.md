# Extension Resolution Policy

Version: 1  
Status: Draft

This document defines deterministic extension resolution precedence, per-artifact
merge behavior, and hard-conflict handling.

## Deterministic Precedence Order

Resolution MUST apply sources in this precedence order:

1. Project-local overrides (highest precedence)
2. Enabled extensions in explicit project order (left-to-right)
3. Core defaults (lowest precedence)

Given identical project config and enabled extension order, the resolver MUST
produce identical output across runs.

## Resolution Inputs

- `core defaults`: baseline capabilities and templates bundled with SDD core
- `enabled extensions`: extension set ordered in project configuration
- `project-local overrides`: project-specific artifacts that intentionally
  override extension/core artifacts

## Artifact Merge Semantics

### `skills`

- Merge mode: ordered union by stable key (artifact path or identifier)
- Duplicate key behavior: later source in precedence order replaces earlier
- Result order: deterministic by effective precedence then declaration order

### `rules`

- Merge mode: ordered union by rule id
- Duplicate id behavior: later source in precedence order replaces earlier
- Conflict note: semantic incompatibility between rules can be hard conflict

### `checklists`

- Merge mode: ordered append by checklist id
- Duplicate id behavior: later source replaces earlier definition

### `templates`

- Merge mode: map merge by template id
- Duplicate id behavior: later source in precedence order replaces earlier

### Unknown Artifact Type

- Classification: hard conflict
- Behavior: fail-fast with remediation guidance

## Hard-Conflict Classification

A conflict MUST be classified as hard when any of the following is true:

- Explicit manifest conflict (`extension_a` declares `extension_b` in `conflicts`)
- Unsatisfied dependency (`extension_a` requires `extension_b`, not enabled)
- Incompatible artifact semantics that cannot be safely merged deterministically
- Unknown artifact type encountered in resolution inputs

Soft warnings may be emitted for non-fatal overlap, but hard conflicts MUST
stop resolution.

## Fail-Fast Behavior

On first hard conflict, resolution MUST:

1. Stop immediately (do not continue best-effort merge)
2. Return failure envelope with conflict classification
3. Include deterministic remediation guidance

Canonical failure envelope:

```json
{
  "status": "error",
  "error": {
    "code": "HARD_CONFLICT",
    "message": "Extension conflict detected between 'security-hardening' and 'legacy-auth'.",
    "details": {
      "conflict_type": "declared_conflict",
      "extension_a": "security-hardening",
      "extension_b": "legacy-auth"
    },
    "remediation": {
      "actions": [
        "Disable one conflicting extension",
        "Replace with a compatible alternative",
        "Adjust project enablement order only if conflict type allows ordering fixes"
      ],
      "docs": [
        "docs/extensions/project-config-contract.md",
        "docs/extensions/extension-contract.md"
      ]
    }
  }
}
```

## Remediation Guidance Format

Remediation guidance MUST include:

- `actions`: ordered, actionable operator steps
- `docs`: internal contract references for resolution support
- `conflict_type`: machine-parseable classification value

Recommended `conflict_type` values:

- `declared_conflict`
- `missing_dependency`
- `artifact_incompatibility`
- `unknown_artifact_type`

## Deterministic Walkthrough

Input order:

```yaml
extensions:
  enabled:
    - web-api-baseline
    - security-hardening
```

Walkthrough steps:

1. Load `extensions.enabled` from project config in listed order
2. Start from core defaults
3. Merge artifacts from `web-api-baseline`
4. Merge artifacts from `security-hardening`
5. Apply project-local overrides
6. Stop immediately if a hard conflict is detected at any step

Outcome guarantees:

- Repeated runs with same input produce same merged artifact set
- If `security-hardening` hard-conflicts with `web-api-baseline`, resolution
  fails immediately with `HARD_CONFLICT`
- Failure response includes the remediation guidance structure defined above

## Cross-References

- Extension id and manifest dependency/conflict fields:
  `docs/extensions/extension-contract.md`
- Project enablement shape and ordered input contract:
  `docs/extensions/project-config-contract.md`
- Lifecycle command diagnostics and correction hint style:
  `docs/extensions/command-contract.md`

## Versioning and Forward Compatibility

- Merge semantics are versioned; breaking precedence changes require major bump
- New artifact types require explicit contract updates before resolver support
- Unknown artifact types in v1 remain hard conflicts by design
