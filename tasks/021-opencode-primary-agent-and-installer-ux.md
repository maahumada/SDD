# Task 021: OpenCode Primary Agent and Installer UX

**Priority**: High  
**Status**: Completed  
**Depends on**: 014-opencode-adapter-and-command-pack.md, 020-docs-for-adapter-installation-and-updates.md

---

## Objective

Improve OpenCode onboarding and daily UX by making SDD available as a primary
agent, adding a one-command OpenCode installer, and clarifying command usage.

## Deliverables

- Update OpenCode agent name to `SDD` as primary mode
- Add OpenCode global installer script
- Add short usage hints in `/sdd-*` command descriptions
- Update docs to reflect non-interactive installer behavior and OpenCode setup

## Scope

Implemented changes:
- `examples/opencode/opencode.json`: primary agent renamed to `SDD`
- `examples/opencode/commands/sdd-*.md`: command descriptions include compact
  usage syntax and route to `agent: SDD`
- `templates/opencode/commands/sdd-*.md`: same updates for installable templates
- `scripts/sdd-install-opencode.sh`: install skills + commands + merge agent
  entry in `~/.config/opencode/opencode.json`
- `scripts/sdd-install.sh`: non-interactive overwrite by default
- `scripts/lib/sdd-adapter-lib.sh`: remove interactive prompt for unmarked files
- `scripts/test-install-update.sh`: updated assertions for overwrite-by-default
- `README.md`, `docs/adapter-installation.md`,
  `examples/opencode/sdd-orchestrator.md`,
  `templates/opencode/sdd-orchestrator.md`: docs aligned with new UX

## Acceptance Criteria

- [x] OpenCode primary agent name is `SDD`
- [x] OpenCode command files target `agent: SDD`
- [x] Command descriptions include short usage hints
- [x] `scripts/sdd-install-opencode.sh` exists and is executable
- [x] Installer migrates legacy `sdd-orchestrator` agent key to `SDD`
- [x] Install flow is non-interactive by default
- [x] Smoke tests pass after behavior changes
- [x] README and adapter-installation docs reflect the updated UX
