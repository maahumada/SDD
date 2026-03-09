# SDD Template Pack

This directory contains installable templates for SDD adapters.

## Managed Block Marker Convention

Templates include managed block markers so installer/update scripts can patch
only SDD-owned content and preserve user edits outside the managed region.

Marker format:

```text
<!-- SDD:BEGIN adapter=<ADAPTER_ID> version=<N> -->
... managed content ...
<!-- SDD:END adapter=<ADAPTER_ID> -->
```

Rules:
- `adapter` identifies the block target.
- `version` increments when template behavior changes.
- Installer and updater replace the full block between matching BEGIN/END lines.

## Template Groups

- `templates/adapters/` -> root adapter files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`)
- `templates/opencode/commands/` -> OpenCode command pack (`sdd-*.md`)
- `templates/opencode/sdd-orchestrator.md` -> OpenCode adapter setup snippet
