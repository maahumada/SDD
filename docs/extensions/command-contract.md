# Extension Lifecycle Command Contract

Version: 1  
Status: Draft

This document defines the canonical grammar, validation behavior, and output
envelope conventions for extension lifecycle commands.

## Canonical Format

```text
/sdd-ext-<command> [args...] [-- <free-text-prompt>]
```

Rules:
- `/sdd-ext-<command>` is always lowercase.
- Positional args come before `--`.
- `--` separates structured args from free text.
- Free text after `--` is passed as-is when the command supports prompt input.

## Command Set

| Command | Required Args | Optional Args | Prompt Segment | Purpose |
|---------|---------------|---------------|----------------|---------|
| `/sdd-ext-create` | `<extension-id>` | none | optional: `-- <description-or-notes>` | Initialize a new extension skeleton and manifest stub. |
| `/sdd-ext-validate` | `<path-or-id>` | none | not used | Validate extension manifest and structure against contracts. |
| `/sdd-ext-list` | none | `[--enabled]` | not used | List installed extensions, optionally filtering to enabled only. |
| `/sdd-ext-enable` | `<extension-id>` | `[--order <index>]` | optional: `-- <reason-or-notes>` | Enable an extension for the current project with deterministic order. |
| `/sdd-ext-disable` | `<extension-id>` | none | optional: `-- <reason-or-notes>` | Disable an extension for the current project. |
| `/sdd-ext-inspect` | `<extension-id>` | `[--json]` | not used | Inspect extension metadata, capabilities, and compatibility. |

## Argument Grammar

### EBNF

```ebnf
command-line   = command, { " ", arg }, [ " ", "--", " ", prompt ] ;
command        = "/sdd-ext-create" | "/sdd-ext-validate" |
                 "/sdd-ext-list" | "/sdd-ext-enable" |
                 "/sdd-ext-disable" | "/sdd-ext-inspect" ;
arg            = token ;
token          = 1*( ALNUM | "-" | "." | "_" | "/" ) ;
prompt         = 1*CHAR ;
```

### `extension-id`

Validation rule:

```regex
^[a-z0-9][a-z0-9-]{1,62}$
```

### `path-or-id`

May be one of:
- Canonical extension id (same rule as `extension-id`)
- Relative filesystem path to extension root

### `--order <index>`

Validation rule:
- `<index>` MUST be an integer greater than or equal to `0`

## Deterministic Validation Behavior

Validation MUST execute in this order:

1. Parse command token and argument positions.
2. Validate command-specific required and optional argument shape.
3. Validate `extension-id` format when applicable.
4. Validate prompt payload usage (`--`) against command rules.
5. Return canonical success envelope or canonical error envelope.

If an earlier step fails, later steps MUST NOT execute.

## Output Envelope

Successful command responses MUST follow this shape:

```json
{
  "status": "ok",
  "command": "sdd-ext-enable",
  "result": {
    "message": "Extension enabled",
    "extension_id": "web-api-baseline"
  }
}
```

Failed command responses MUST follow this shape:

```json
{
  "status": "error",
  "error": {
    "code": "INVALID_ARGUMENT",
    "message": "Invalid extension id 'Web_API_Baseline'.",
    "hint": "Use lowercase kebab-case. Example: web-api-baseline"
  }
}
```

## Canonical Error Behavior and Correction Hints

### Unknown Command

Condition:
- Command is not part of the canonical `/sdd-ext-*` set.

Response:

```text
Unknown command '<input>'. Supported commands:
/sdd-ext-create, /sdd-ext-validate, /sdd-ext-list, /sdd-ext-enable, /sdd-ext-disable, /sdd-ext-inspect
```

### Missing Required `extension-id`

Applies to:
- `/sdd-ext-create`, `/sdd-ext-enable`, `/sdd-ext-disable`, `/sdd-ext-inspect`

Response example:

```text
Missing required argument: <extension-id>
Usage: /sdd-ext-enable <extension-id> [--order <index>] [-- <reason-or-notes>]
```

### Invalid `extension-id`

Condition:
- Does not match `^[a-z0-9][a-z0-9-]{1,62}$`.

Response example:

```text
Invalid extension id 'Web_API_Baseline'. Use lowercase letters, numbers, and hyphens.
Example: web-api-baseline
```

### Missing `--order` Value

Condition:
- `/sdd-ext-enable` includes `--order` without a value.

Response example:

```text
Missing value for --order.
Usage: /sdd-ext-enable <extension-id> [--order <index>] [-- <reason-or-notes>]
```

### Invalid `--order` Value

Condition:
- `--order` value is not an integer >= 0.

Response example:

```text
Invalid --order value '-1'. Provide an integer >= 0.
Example: /sdd-ext-enable web-api-baseline --order 0
```

### Unexpected Prompt Segment

Condition:
- Command that does not allow a prompt receives `-- <text>`.

Response example:

```text
Command '/sdd-ext-list' does not accept a prompt segment.
Usage: /sdd-ext-list [--enabled]
```

## Compatibility Policy

Adapters MAY accept compatibility shorthand forms and MUST emit a canonical
correction hint.

Accepted forms:
- `/sdd-ext-create <extension-id> <notes without -->`
- `/sdd-ext-enable <extension-id> <notes without -->`

Warning format:

```text
Compatibility parse applied. Preferred syntax:
/sdd-ext-enable <extension-id> [--order <index>] [-- <reason-or-notes>]
```

## Canonical Examples

```text
/sdd-ext-create web-api-baseline -- shared baseline for API projects

/sdd-ext-validate ./extensions/web-api-baseline

/sdd-ext-list --enabled

/sdd-ext-enable web-api-baseline --order 0 -- required by API starter template

/sdd-ext-disable web-api-baseline -- no longer needed in this service

/sdd-ext-inspect web-api-baseline --json
```

## Parseability Verification Against Core Grammar

The canonical examples above are parseable using the same positional argument
and prompt-boundary conventions defined in `docs/sdd-command-contract.md`:

- Command token appears first and is lowercase
- Positional args appear before `--`
- Prompt payload appears only after `--` for commands that allow prompt input
- Option flags (`--enabled`, `--order`, `--json`) remain part of structured args

Example alignment checks:

- `/sdd-ext-enable web-api-baseline --order 0 -- required by API starter template`
  - Structured args: `web-api-baseline --order 0`
  - Prompt payload: `required by API starter template`
- `/sdd-ext-list --enabled`
  - Structured args only
  - No prompt payload

## Cross-Reference

This contract intentionally mirrors grammar and correction-hint conventions from
`docs/sdd-command-contract.md`.

## Versioning and Forward Compatibility

- Breaking command grammar or envelope changes MUST increment major version
- New optional flags MAY be added without breaking existing parsers
- Consumers SHOULD ignore unknown optional result fields in success envelopes
