# Extension Pack Contract

Version: 1  
Status: Draft

This document defines the canonical structure and manifest requirements for SDD
extension packs.

## Canonical Extension Pack Layout

An extension pack MUST use the following layout:

```text
<extension-root>/
  manifest.yaml
  README.md
  skills/
  rules/
  checklists/
  templates/
```

Required artifacts:
- `manifest.yaml`: machine-parseable identity and capability declaration
- `README.md`: human-facing purpose, install notes, and usage guidance

Optional artifacts:
- `skills/`: extension-specific orchestrator or phase skills
- `rules/`: policy snippets consumed during apply/verify
- `checklists/`: reusable quality or review checklists
- `templates/`: proposal/spec/design/task templates

## Manifest Contract

The extension manifest MUST conform to `docs/extensions/manifest-schema.yaml`.

Required top-level fields:
- `schema_version`
- `id`
- `name`
- `version`
- `provides`
- `compatibility`

Optional top-level fields:
- `description`
- `dependencies`
- `conflicts`

## Identifier Rules

The `id` field MUST match:

```regex
^[a-z0-9][a-z0-9-]{1,62}$
```

Rules:
- Lowercase letters, numbers, and hyphens only
- Must start with a letter or number
- Length must be 2 to 63 characters

## Identifier Validation Examples

These examples are tied to the specification scenario: "Invalid extension
identifier is rejected by contract."

| Example ID | Valid | Reason |
|------------|-------|--------|
| `web-api-baseline` | yes | kebab-case, lowercase, allowed characters |
| `security-hardening-v2` | yes | lowercase alphanumeric with hyphens |
| `Web_API_Baseline` | no | contains uppercase and underscore |
| `-baseline` | no | starts with hyphen |
| `a` | no | too short (minimum length is 2) |

## Minimal Valid Manifest Example

```yaml
schema_version: 1
id: web-api-baseline
name: Web API Baseline
version: 0.1.0
provides:
  skills: []
  rules: []
  checklists: []
  templates: []
compatibility:
  sdd: ">=1.0.0 <2.0.0"
dependencies: []
conflicts: []
```

## Invalid Identifier Example

```yaml
schema_version: 1
id: Web_API_Baseline
name: Invalid Identifier Example
version: 0.1.0
provides:
  skills: []
  rules: []
  checklists: []
  templates: []
compatibility:
  sdd: ">=1.0.0 <2.0.0"
```

Expected validation result:
- Fail with a rule-based message indicating `id` does not match
  `^[a-z0-9][a-z0-9-]{1,62}$`.

## Cross-References

- Project enablement ordering and lock-file treatment:
  `docs/extensions/project-config-contract.md`
- Lifecycle command grammar and correction hints:
  `docs/extensions/command-contract.md`
- Deterministic merge and hard-conflict behavior:
  `docs/extensions/resolution-policy.md`

## Versioning and Forward Compatibility

- Manifest `schema_version` MUST be incremented for breaking schema changes
- Additive fields SHOULD be optional to preserve compatibility for v1 consumers
- Consumers MUST reject manifests that declare unsupported major schema versions
