# SDD Command Contract

Version: 1  
Status: Active

This document defines the canonical command grammar for SDD orchestration.
All command entrypoints and model adapters must follow this contract.

## Canonical Format

```
/sdd-<command> [args...] [-- <free-text-prompt>]
```

Rules:
- `/sdd-<command>` is always lowercase.
- Positional args come before `--`.
- `--` separates structured args from free text.
- Free text after `--` is passed as-is to orchestrator logic.

## Command Set

| Command | Required Args | Optional Args | Prompt Segment | Purpose |
|---------|---------------|---------------|----------------|---------|
| `/sdd-explore` | none | none | required: `-- <topic>` | Explore a topic and return analysis. |
| `/sdd-new` | `<change-name>` | none | required: `-- <prompt>` | Start a new change with exploration and proposal. |
| `/sdd-continue` | none | `[change-name]` | not used | Run next dependency-ready phase for active change. |
| `/sdd-ff` | `<change-name>` | none | optional: `-- <prompt>` | Fast-forward planning artifacts for a change. |
| `/sdd-apply` | `<change-name>` | none | optional: `-- <task-range-or-note>` | Implement task batch for a change. |
| `/sdd-verify` | `<change-name>` | none | not used | Verify implementation against specs and tasks. |

## Argument Grammar

### EBNF

```ebnf
command-line   = command, { " ", arg }, [ " ", "--", " ", prompt ] ;
command        = "/sdd-explore" | "/sdd-new" | "/sdd-continue" |
                 "/sdd-ff" | "/sdd-apply" | "/sdd-verify" ;
arg            = token ;
token          = 1*( ALNUM | "-" | "." | "_" ) ;
prompt         = 1*CHAR ;
```

### `change-name`

Validation rule:

```regex
^[a-z0-9][a-z0-9-]{1,62}$
```

Guidance:
- Use kebab-case.
- Keep names stable for artifact paths inside `.sdd/changes/{change-name}/`.

### `task-range-or-note`

May be one of:
- Task range: `1.1-1.3`
- Single task: `2.4`
- Phase tag: `phase-2`
- Free-text note: `focus only on backend tasks`

## Parsing Rules

1. Identify command token (first token).
2. Locate first `--` token, if present.
3. Tokens before `--` are parsed as positional args.
4. Text after `--` is captured as raw prompt payload.
5. Validate command-specific arg requirements.
6. Return normalized object to orchestrator.

Normalized shape:

```json
{
  "command": "sdd-new",
  "args": {
    "change_name": "add-dark-mode"
  },
  "prompt": "add toggle, persist preference, include tests"
}
```

## Validation and Error Behavior

### Unknown Command

Condition:
- Command is not part of the canonical `/sdd-*` set.

Response:

```text
Unknown command '<input>'. Supported commands:
/sdd-explore, /sdd-new, /sdd-continue, /sdd-ff, /sdd-apply, /sdd-verify
```

### Missing Required `change-name`

Applies to:
- `/sdd-new`, `/sdd-ff`, `/sdd-apply`, `/sdd-verify`

Response example:

```text
Missing required argument: <change-name>
Usage: /sdd-new <change-name> -- <prompt>
```

### Missing Required Prompt Segment

Applies to:
- `/sdd-explore`, `/sdd-new`

Response example:

```text
Missing prompt payload after '--'
Usage: /sdd-new <change-name> -- <prompt>
```

### Empty Prompt Payload

Condition:
- `--` is present but nothing follows.

Response example:

```text
Prompt payload cannot be empty.
Provide text after '--'.
```

### Invalid `change-name`

Condition:
- Does not match `^[a-z0-9][a-z0-9-]{1,62}$`.

Response example:

```text
Invalid change name 'Add_Dark_Mode'. Use kebab-case, lowercase letters, numbers, and hyphens.
Example: add-dark-mode
```

### Unexpected Extra Positional Args

Condition:
- Command receives positional args beyond allowed schema.

Response example:

```text
Too many positional arguments for /sdd-verify.
Usage: /sdd-verify <change-name>
```

## Compatibility Policy (Non-Canonical Input)

To reduce friction, parser may accept selected shorthand inputs and emit a
warning with a canonical suggestion.

Accepted compatibility forms:
- `/sdd-explore <topic without -->`
- `/sdd-new <change-name> <prompt without -->`
- `/sdd-apply <change-name> <task-range>`

Warning format:

```text
Compatibility parse applied. Preferred syntax:
/sdd-new <change-name> -- <prompt>
```

Adapters should preserve this compatibility behavior consistently.

## Canonical Examples

```text
/sdd-explore -- evaluate current auth architecture and failure points

/sdd-new add-dark-mode -- add theme toggle, system preference fallback, and persisted choice

/sdd-continue add-dark-mode

/sdd-ff add-dark-mode -- regenerate planning artifacts after updated proposal

/sdd-apply add-dark-mode -- 1.1-1.3

/sdd-verify add-dark-mode
```

## Adapter Conformance

All adapter files must conform to this command contract:
- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`
- OpenCode command files

When updating this contract, also update adapter templates and router docs.
