# Task 016: Create Adapter Template Pack

**Priority**: High  
**Status**: Pending  
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

- [ ] `templates/adapters/` exists with adapter templates
- [ ] `templates/opencode/commands/` exists with canonical `/sdd-*` commands
- [ ] Templates follow grammar from Task 008 (`--` separator where required)
- [ ] Managed block markers are present and documented
- [ ] No references to `engram`, `hybrid`, or `openspec` naming
