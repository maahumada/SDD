#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SDD_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

# shellcheck source=lib/sdd-adapter-lib.sh
. "$SCRIPT_DIR/lib/sdd-adapter-lib.sh"

usage() {
  cat <<'EOF'
Usage: scripts/sdd-install.sh --project <path> [options]

Install SDD adapter templates into a target project.

Required:
  --project <path>          Target project root

Options:
  --adapters <list>         Comma-separated adapters (default: agents,claude,gemini,opencode)
  --dry-run                 Show actions without modifying files
  --force                   Deprecated compatibility flag (overwrite is default)
  --yes                     Deprecated compatibility flag (installer is non-interactive)
  --no-backup               Do not create backups before modifying files
  --help                    Show this help

Examples:
  scripts/sdd-install.sh --project ../my-repo
  scripts/sdd-install.sh --project ../my-repo --adapters agents,claude
  scripts/sdd-install.sh --project ../my-repo --adapters opencode --dry-run
EOF
}

PROJECT_PATH=""
ADAPTERS_RAW="agents,claude,gemini,opencode"
DRY_RUN=0
FORCE=0
YES=0
BACKUP_ENABLED=1

while [ "$#" -gt 0 ]; do
  case "$1" in
    --project)
      [ "$#" -ge 2 ] || sdd_die "Missing value for --project"
      PROJECT_PATH="$2"
      shift 2
      ;;
    --adapters)
      [ "$#" -ge 2 ] || sdd_die "Missing value for --adapters"
      ADAPTERS_RAW="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --yes)
      YES=1
      shift
      ;;
    --no-backup)
      BACKUP_ENABLED=0
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      sdd_die "Unknown argument: $1"
      ;;
  esac
done

[ -n "$PROJECT_PATH" ] || sdd_die "--project is required"

if [ ! -d "$PROJECT_PATH" ]; then
  sdd_die "Project path does not exist: $PROJECT_PATH"
fi

PROJECT_ABS=$(CDPATH= cd -- "$PROJECT_PATH" && pwd)
ADAPTERS=$(sdd_validate_adapters "$ADAPTERS_RAW")

sdd_log "INFO" "Installing adapters into $PROJECT_ABS"
sdd_log "INFO" "Adapters: $(printf "%s" "$ADAPTERS" | tr ' ' ',')"

if [ "$DRY_RUN" -eq 1 ]; then
  sdd_log "INFO" "Dry-run mode enabled"
fi

if [ "$FORCE" -eq 1 ]; then
  sdd_log "INFO" "--force provided (compatibility mode; overwrite is already default)"
fi

if [ "$YES" -eq 1 ]; then
  sdd_log "INFO" "--yes provided (compatibility mode; installer is non-interactive)"
fi

for adapter in $ADAPTERS; do
  sdd_log "INFO" "Processing adapter: $adapter"
  while IFS='|' read -r template_rel target_rel; do
    [ -n "$template_rel" ] || continue
    template_path="$SDD_ROOT/$template_rel"
    target_path="$PROJECT_ABS/$target_rel"

    if [ ! -f "$template_path" ]; then
      sdd_die "Template not found: $template_path"
    fi

    sdd_apply_template_install "$template_path" "$target_path" "$DRY_RUN" "$FORCE" "$YES" "$BACKUP_ENABLED"
  done <<EOF
$(sdd_targets_for_adapter "$adapter")
EOF
done

sdd_log "INFO" "Install completed"
