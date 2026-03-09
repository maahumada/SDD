# Project Extension Configuration Contract

Version: 1  
Status: Draft

This document defines the canonical project-level extension enablement
configuration consumed by extension lifecycle and resolution flows.

## Canonical Project Configuration Shape

Projects that use extensions MUST define enablement under a top-level
`extensions` key.

```yaml
extensions:
  enabled:
    - web-api-baseline
    - security-hardening
```

Required fields:
- `extensions.enabled`

Optional fields:
- `extensions.lock_file`

## Field Definitions

### `extensions.enabled`

- Type: array of extension ids
- Validation: each id MUST match `^[a-z0-9][a-z0-9-]{1,62}$`
- Semantics: list order MUST be treated as explicit precedence input

### `extensions.lock_file`

- Type: string path
- Default recommendation: `.sdd/extensions.lock.yaml`
- v1 treatment: lock-file generation and enforcement are deferred
- v1 behavior: when present, tools MAY surface informational diagnostics, but
  MUST NOT require lock-file presence for command success

## Deterministic Ordering Contract

Resolution MUST consume `extensions.enabled` in listed order and apply merge
semantics defined in `docs/extensions/resolution-policy.md`.

Given identical `extensions.enabled` order and identical extension manifests,
effective artifacts MUST remain stable across runs.

## Validation and Error Behavior

Project configuration validation MUST execute in this order:

1. Confirm top-level `extensions` object exists
2. Confirm `extensions.enabled` exists and is an array
3. Validate each enabled id against identifier rules
4. Validate optional `extensions.lock_file` type when provided

If any step fails, later steps MUST NOT execute.

Canonical error examples:

```text
Missing required field: extensions.enabled
```

```text
Invalid extension id 'Web_API_Baseline' in extensions.enabled[0].
Use lowercase kebab-case. Example: web-api-baseline
```

## Lock-File Treatment

Lock-file support is explicitly deferred for v1.

- Tools SHOULD preserve deterministic behavior without lock-file materialization
- Future versions MAY define required lock-file generation and validation
- Until then, `extensions.lock_file` remains advisory metadata

## Cross-References

- Extension identifier and manifest constraints:
  `docs/extensions/extension-contract.md`
- Resolver precedence and conflict policy:
  `docs/extensions/resolution-policy.md`
- Lifecycle command grammar and diagnostics:
  `docs/extensions/command-contract.md`

## Versioning and Forward Compatibility

- Contract versions are monotonic; breaking changes MUST increment major version
- Unknown future optional fields under `extensions` SHOULD be ignored by v1
  consumers unless explicitly marked required by a newer contract version
