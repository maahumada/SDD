# Adapter Installation and Updates

This guide explains how to install and update SDD adapters in any project.

## Quickstart

From this repository root:

```bash
./scripts/sdd-install.sh --project ../my-project --adapters agents,claude
```

Install all supported adapters:

```bash
./scripts/sdd-install.sh --project ../my-project --adapters agents,claude,gemini,opencode
```

Preview changes without writing files:

```bash
./scripts/sdd-install.sh --project ../my-project --adapters agents,opencode --dry-run
```

## Install Script Reference

Script: `scripts/sdd-install.sh`

Required:
- `--project <path>`: target project root.

Options:
- `--adapters <list>`: comma-separated values from `agents,claude,gemini,opencode`.
- `--dry-run`: print actions only, no file modifications.
- `--force`: overwrite files that do not contain SDD managed blocks.
- `--yes`: non-interactive mode.
- `--no-backup`: disable backup creation before modifying existing files.

Examples:

```bash
./scripts/sdd-install.sh --project ../my-project --adapters agents,claude
./scripts/sdd-install.sh --project ../my-project --adapters opencode --dry-run
./scripts/sdd-install.sh --project ../my-project --adapters agents --force
```

## Update Script Reference

Script: `scripts/sdd-update.sh`

Required:
- `--project <path>`: target project root.

Options:
- `--adapters <list>`: comma-separated values from `agents,claude,gemini,opencode`.
- `--dry-run`: print actions only, no file modifications.
- `--no-backup`: disable backup creation before modifying existing files.

Examples:

```bash
./scripts/sdd-update.sh --project ../my-project
./scripts/sdd-update.sh --project ../my-project --adapters agents,opencode
./scripts/sdd-update.sh --project ../my-project --dry-run
```

## Managed Block Policy

Templates use managed block markers so SDD can update only owned sections:

```text
<!-- SDD:BEGIN adapter=<ADAPTER_ID> version=<N> -->
... managed content ...
<!-- SDD:END adapter=<ADAPTER_ID> -->
```

Behavior:
- Installer creates files when missing.
- If a file already contains matching managed markers, only the managed block is replaced.
- User content outside managed markers is preserved.
- Update script never overwrites files that do not contain managed markers.

## Backup Behavior

By default, both scripts create backups before modifying existing files:

```text
<file>.bak.<timestamp>
```

Disable backups explicitly with `--no-backup`.

## Recommended Team Workflow

1. Install adapters into repository.
2. Review generated files.
3. Commit adapter files.
4. Periodically run update script when template pack changes.
5. Re-run smoke tests before broad rollout:

```bash
./scripts/test-install-update.sh
```

## Troubleshooting

### Conflict: file has no managed markers

Symptom:
- Installer reports conflict for an existing file.

Resolution:
- Use `--force` to overwrite, or add managed block markers manually, or keep
  the file unchanged.

### Missing target file during update

Symptom:
- Updater reports `SKIPPED ... (file missing)`.

Resolution:
- Run installer first, then updater.

### Dry-run output looks correct but file did not change

Expected:
- `--dry-run` is non-destructive by design.

Resolution:
- Re-run without `--dry-run` to apply changes.

### Backup files clutter repository

Resolution:
- Add `*.bak.*` to ignore rules in target project if desired, or run with
  `--no-backup` once process is stable.
