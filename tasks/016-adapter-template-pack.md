# Task 016: Create Adapter Template Pack

**Priority**: High  
**Status**: Completed  
**Depends on**: 010-adapter-core-router-and-sync-policy.md, 011-agents-md-adapter.md, 012-claude-md-adapter.md, 013-gemini-md-adapter.md, 014-opencode-adapter-and-command-pack.md

---

## Objective

Create a template pack that becomes the source for adapter installation into
other projects.

## Deliverables

- `templates/adapters/AGENTS.md`
- `templates/adapters/CLAUDE.md`
- `templates/adapters/GEMINI.md`
- `templates/adapters/sdd-orchestrator.md` (if needed by adapters)
- `templates/opencode/commands/sdd-*.md`

## Scope

Define templates as installable artifacts, separate from project docs.

Include template markers for managed blocks:
- `<!-- SDD:BEGIN ... -->`
- `<!-- SDD:END ... -->`

These markers will let install/update scripts patch only SDD-managed sections.

## Acceptance Criteria

- [x] `templates/adapters/` exists with adapter templates
- [x] `templates/opencode/commands/` exists with canonical `/sdd-*` commands
- [x] Templates follow grammar from Task 008 (`--` separator where required)
- [x] Managed block markers are present and documented
- [x] No references to `engram`, `hybrid`, or `openspec` naming
