# Task 017: Build Installer Script for Project Adapters

**Priority**: High  
**Status**: Completed  
**Depends on**: 016-adapter-template-pack.md

---

## Objective

Create an idempotent installer script to copy SDD adapters into target projects.

## Deliverable

Create `scripts/sdd-install.sh`.

## Scope

Script behavior:
- Install selected adapters from `templates/` into a target project
- Create files when missing
- Update only managed SDD blocks when files already exist
- Preserve user content outside managed blocks
- Create backup files before modifications (default enabled)

Required flags:
- `--project <path>` (target project root)
- `--adapters <list>` (for example: `agents,claude,gemini,opencode`)
- `--dry-run`
- `--force` (allow overwrite when no managed block is found)
- `--yes` (non-interactive mode)
- `--no-backup`

## Notes

- Keep script POSIX-compatible where practical
- Print clear action logs: create/update/skip/error
- Exit non-zero on validation errors

## Acceptance Criteria

- [x] File created at `scripts/sdd-install.sh`
- [x] Installer supports required flags and validates input
- [x] Installer is idempotent (second run does not duplicate content)
- [x] Existing files are preserved outside SDD-managed blocks
- [x] Backups are created unless `--no-backup` is passed
- [x] Script includes usage/help output
