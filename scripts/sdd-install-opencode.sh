#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SDD_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

# shellcheck source=lib/sdd-adapter-lib.sh
. "$SCRIPT_DIR/lib/sdd-adapter-lib.sh"

usage() {
  cat <<'EOF'
Usage: scripts/sdd-install-opencode.sh [options]

Install SDD assets into an OpenCode config directory.

Options:
  --target-config <path>    OpenCode config root (default: ~/.config/opencode)
  --dry-run                 Show actions without writing files
  --force                   Compatibility flag (overwrite is default)
  --yes                     Compatibility flag (installer is non-interactive)
  --no-backup               Do not create backups before modifying files
  --skip-skills             Skip installing skills/sdd-*
  --skip-commands           Skip installing command pack
  --skip-agent              Skip updating opencode.json agent entry
  --help                    Show this help

Examples:
  scripts/sdd-install-opencode.sh
  scripts/sdd-install-opencode.sh --target-config /tmp/opencode --dry-run
  scripts/sdd-install-opencode.sh --force --yes
EOF
}

TARGET_CONFIG="${HOME}/.config/opencode"
DRY_RUN=0
FORCE=0
YES=0
BACKUP_ENABLED=1
SKIP_SKILLS=0
SKIP_COMMANDS=0
SKIP_AGENT=0

prompt_replace() {
  target_path="$1"
  # Non-interactive by default: always replace existing skill dirs.
  # Keep force/yes flags for backward compatibility.
  : "$target_path" "$FORCE" "$YES"
  return 0
}

ensure_dir() {
  dir_path="$1"
  if [ "$DRY_RUN" -eq 1 ]; then
    if [ ! -d "$dir_path" ]; then
      sdd_log "DRY-RUN" "mkdir -p $dir_path"
    fi
    return 0
  fi
  mkdir -p "$dir_path"
}

replace_skill_dir() {
  src_dir="$1"
  dst_dir="$2"

  if [ ! -d "$dst_dir" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      sdd_log "DRY-RUN" "copy skill dir $src_dir -> $dst_dir"
      return 0
    fi
    cp -R "$src_dir" "$dst_dir"
    sdd_log "CREATED" "$dst_dir"
    return 0
  fi

  if ! prompt_replace "$dst_dir"; then
    sdd_log "SKIPPED" "$dst_dir"
    return 0
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    sdd_log "DRY-RUN" "replace skill dir $dst_dir"
    return 0
  fi

  if [ "$BACKUP_ENABLED" -eq 1 ]; then
    backup_dir="${dst_dir}.bak.$(sdd_timestamp)"
    cp -R "$dst_dir" "$backup_dir"
    sdd_log "BACKUP" "$backup_dir"
  fi

  rm -rf "$dst_dir"
  cp -R "$src_dir" "$dst_dir"
  sdd_log "UPDATED" "$dst_dir"
}

merge_opencode_agent() {
  target_json="$1"
  source_json="$2"
  tmp_file=$(mktemp)

status=$(python3 - "$target_json" "$source_json" "$FORCE" "$tmp_file" <<'PY'
import json
import sys

target_path, source_path, force_flag, out_path = sys.argv[1:]
force = force_flag == "1"

PRIMARY_KEY = "SDD"
LEGACY_KEY = "sdd-orchestrator"

with open(target_path, "r", encoding="utf-8") as f:
    target = json.load(f)

with open(source_path, "r", encoding="utf-8") as f:
    source = json.load(f)

entry = source.get("agent", {}).get(PRIMARY_KEY)
if entry is None:
    raise SystemExit(f"source opencode.json missing agent.{PRIMARY_KEY}")

if not isinstance(target, dict):
    raise SystemExit("target opencode.json root must be an object")

agent = target.get("agent")
if not isinstance(agent, dict):
    agent = {}
    target["agent"] = agent

if PRIMARY_KEY in agent:
    if agent[PRIMARY_KEY] == entry:
        status = "unchanged"
    else:
        agent[PRIMARY_KEY] = entry
        status = "updated"
elif LEGACY_KEY in agent:
    del agent[LEGACY_KEY]
    agent[PRIMARY_KEY] = entry
    status = "migrated"
else:
    agent[PRIMARY_KEY] = entry
    status = "added"

with open(out_path, "w", encoding="utf-8") as f:
    json.dump(target, f, indent=2)
    f.write("\n")

print(status)
PY
)

  case "$status" in
    unchanged)
      rm -f "$tmp_file"
      sdd_log "UNCHANGED" "$target_json"
      return 0
      ;;
    added|updated|migrated)
      if [ "$DRY_RUN" -eq 1 ]; then
        rm -f "$tmp_file"
        sdd_log "DRY-RUN" "$status agent.SDD in $target_json"
        return 0
      fi

      if [ "$BACKUP_ENABLED" -eq 1 ]; then
        backup_path=$(sdd_backup_file "$target_json")
        sdd_log "BACKUP" "$backup_path"
      fi

      mv "$tmp_file" "$target_json"
      sdd_log "UPDATED" "$target_json ($status SDD agent)"
      return 0
      ;;
    *)
      rm -f "$tmp_file"
      sdd_die "Unexpected merge status: $status"
      ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target-config)
      [ "$#" -ge 2 ] || sdd_die "Missing value for --target-config"
      TARGET_CONFIG="$2"
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
    --skip-skills)
      SKIP_SKILLS=1
      shift
      ;;
    --skip-commands)
      SKIP_COMMANDS=1
      shift
      ;;
    --skip-agent)
      SKIP_AGENT=1
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

if ! command -v python3 >/dev/null 2>&1; then
  sdd_die "python3 is required to merge opencode.json"
fi

TARGET_ABS="$TARGET_CONFIG"
if [ -d "$TARGET_CONFIG" ]; then
  TARGET_ABS=$(CDPATH= cd -- "$TARGET_CONFIG" && pwd)
fi

sdd_log "INFO" "Installing SDD for OpenCode"
sdd_log "INFO" "Target config: $TARGET_ABS"
if [ "$DRY_RUN" -eq 1 ]; then
  sdd_log "INFO" "Dry-run mode enabled"
fi

if [ "$FORCE" -eq 1 ]; then
  sdd_log "INFO" "--force provided (compatibility mode; overwrite is already default)"
fi

if [ "$YES" -eq 1 ]; then
  sdd_log "INFO" "--yes provided (compatibility mode; installer is non-interactive)"
fi

ensure_dir "$TARGET_CONFIG"

if [ "$SKIP_SKILLS" -eq 0 ]; then
  ensure_dir "$TARGET_CONFIG/skills"
  for src_skill in "$SDD_ROOT"/skills/sdd-*; do
    [ -d "$src_skill" ] || continue
    skill_name=$(basename "$src_skill")
    dst_skill="$TARGET_CONFIG/skills/$skill_name"
    replace_skill_dir "$src_skill" "$dst_skill"
  done
else
  sdd_log "SKIPPED" "skills installation (--skip-skills)"
fi

if [ "$SKIP_COMMANDS" -eq 0 ]; then
  ensure_dir "$TARGET_CONFIG/commands"
  for template in "$SDD_ROOT"/templates/opencode/commands/sdd-*.md; do
    [ -f "$template" ] || continue
    target_cmd="$TARGET_CONFIG/commands/$(basename "$template")"
    sdd_apply_template_install "$template" "$target_cmd" "$DRY_RUN" "$FORCE" "$YES" "$BACKUP_ENABLED"
  done
else
  sdd_log "SKIPPED" "command installation (--skip-commands)"
fi

if [ "$SKIP_AGENT" -eq 0 ]; then
  source_json="$SDD_ROOT/examples/opencode/opencode.json"
  target_json="$TARGET_CONFIG/opencode.json"

  if [ ! -f "$target_json" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      sdd_log "DRY-RUN" "create $target_json"
    else
      cp "$source_json" "$target_json"
      sdd_log "CREATED" "$target_json"
    fi
  else
    merge_opencode_agent "$target_json" "$source_json"
  fi
else
  sdd_log "SKIPPED" "agent config merge (--skip-agent)"
fi

sdd_log "INFO" "OpenCode installation completed"
sdd_log "INFO" "Use /sdd-new <change-name> -- <prompt> in OpenCode"
