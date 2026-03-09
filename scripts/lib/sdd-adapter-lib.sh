#!/usr/bin/env sh

sdd_log() {
  level="$1"
  shift
  printf "%s: %s\n" "$level" "$*"
}

sdd_die() {
  sdd_log "ERROR" "$*"
  exit 1
}

sdd_timestamp() {
  date +"%Y%m%d%H%M%S"
}

sdd_extract_adapter_id() {
  template_path="$1"
  begin_line=$(grep -m1 '^<!-- SDD:BEGIN adapter=' "$template_path" 2>/dev/null || true)
  if [ -z "$begin_line" ]; then
    return 1
  fi
  adapter_id=$(printf "%s\n" "$begin_line" | sed -E 's/^<!-- SDD:BEGIN adapter=([^ ]+) version=[0-9]+ -->$/\1/')
  if [ -z "$adapter_id" ] || [ "$adapter_id" = "$begin_line" ]; then
    return 1
  fi
  printf "%s\n" "$adapter_id"
}

sdd_has_managed_block() {
  file_path="$1"
  adapter_id="$2"
  if [ ! -f "$file_path" ]; then
    return 1
  fi
  if grep -Eq "^<!-- SDD:BEGIN adapter=${adapter_id} version=[0-9]+ -->$" "$file_path" && \
     grep -Fqx "<!-- SDD:END adapter=${adapter_id} -->" "$file_path"; then
    return 0
  fi
  return 1
}

sdd_backup_file() {
  file_path="$1"
  backup_path="${file_path}.bak.$(sdd_timestamp)"
  cp "$file_path" "$backup_path"
  printf "%s\n" "$backup_path"
}

sdd_replace_block() {
  template_path="$1"
  target_path="$2"
  adapter_id="$3"
  output_path="$4"

  end_line="<!-- SDD:END adapter=${adapter_id} -->"

  awk -v begin_re="^<!-- SDD:BEGIN adapter=${adapter_id} version=[0-9]+ -->$" \
      -v end_line="$end_line" \
      -v repl_file="$template_path" '
BEGIN {
  while ((getline line < repl_file) > 0) {
    repl[++n] = line
  }
  close(repl_file)
}
{
  if ($0 ~ begin_re) {
    for (i = 1; i <= n; i++) {
      print repl[i]
    }
    in_block = 1
    replaced = 1
    next
  }

  if (in_block) {
    if ($0 == end_line) {
      in_block = 0
    }
    next
  }

  print
}
END {
  if (in_block) {
    exit 4
  }
  if (!replaced) {
    exit 3
  }
}
' "$target_path" > "$output_path"
}

sdd_apply_template_install() {
  template_path="$1"
  target_path="$2"
  dry_run="$3"
  force="$4"
  yes_flag="$5"
  backup_enabled="$6"

  adapter_id=$(sdd_extract_adapter_id "$template_path") || \
    sdd_die "Template missing managed block marker: $template_path"

  if [ ! -f "$target_path" ]; then
    if [ "$dry_run" -eq 1 ]; then
      sdd_log "DRY-RUN" "create $target_path"
      return 0
    fi
    parent_dir=$(dirname "$target_path")
    mkdir -p "$parent_dir"
    cp "$template_path" "$target_path"
    sdd_log "CREATED" "$target_path"
    return 0
  fi

  if sdd_has_managed_block "$target_path" "$adapter_id"; then
    tmp_file=$(mktemp)
    if ! sdd_replace_block "$template_path" "$target_path" "$adapter_id" "$tmp_file"; then
      rm -f "$tmp_file"
      sdd_log "ERROR" "Failed replacing managed block in $target_path"
      return 1
    fi

    if cmp -s "$target_path" "$tmp_file"; then
      rm -f "$tmp_file"
      sdd_log "UNCHANGED" "$target_path"
      return 0
    fi

    if [ "$dry_run" -eq 1 ]; then
      rm -f "$tmp_file"
      sdd_log "DRY-RUN" "update $target_path"
      return 0
    fi

    if [ "$backup_enabled" -eq 1 ]; then
      backup_path=$(sdd_backup_file "$target_path")
      sdd_log "BACKUP" "$backup_path"
    fi

    mv "$tmp_file" "$target_path"
    sdd_log "UPDATED" "$target_path"
    return 0
  fi

  local_force="$force"
  if [ "$local_force" -eq 0 ] && [ "$yes_flag" -eq 0 ]; then
    printf "WARN: %s exists without SDD managed block for %s. Overwrite? [y/N]: " "$target_path" "$adapter_id"
    read answer
    case "$answer" in
      y|Y|yes|YES)
        local_force=1
        ;;
      *)
        ;;
    esac
  fi

  if [ "$local_force" -eq 0 ]; then
    sdd_log "CONFLICT" "$target_path (missing managed block for adapter ${adapter_id}; use --force to overwrite)"
    return 0
  fi

  if [ "$dry_run" -eq 1 ]; then
    sdd_log "DRY-RUN" "overwrite $target_path"
    return 0
  fi

  if [ "$backup_enabled" -eq 1 ]; then
    backup_path=$(sdd_backup_file "$target_path")
    sdd_log "BACKUP" "$backup_path"
  fi

  cp "$template_path" "$target_path"
  sdd_log "UPDATED" "$target_path (overwrite via --force)"
  return 0
}

sdd_apply_template_update() {
  template_path="$1"
  target_path="$2"
  dry_run="$3"
  backup_enabled="$4"

  adapter_id=$(sdd_extract_adapter_id "$template_path") || \
    sdd_die "Template missing managed block marker: $template_path"

  if [ ! -f "$target_path" ]; then
    sdd_log "SKIPPED" "$target_path (file missing)"
    return 0
  fi

  if ! sdd_has_managed_block "$target_path" "$adapter_id"; then
    sdd_log "CONFLICT" "$target_path (no SDD managed block for adapter ${adapter_id}; not overwritten)"
    return 0
  fi

  tmp_file=$(mktemp)
  if ! sdd_replace_block "$template_path" "$target_path" "$adapter_id" "$tmp_file"; then
    rm -f "$tmp_file"
    sdd_log "ERROR" "Failed replacing managed block in $target_path"
    return 1
  fi

  if cmp -s "$target_path" "$tmp_file"; then
    rm -f "$tmp_file"
    sdd_log "UNCHANGED" "$target_path"
    return 0
  fi

  if [ "$dry_run" -eq 1 ]; then
    rm -f "$tmp_file"
    sdd_log "DRY-RUN" "update $target_path"
    return 0
  fi

  if [ "$backup_enabled" -eq 1 ]; then
    backup_path=$(sdd_backup_file "$target_path")
    sdd_log "BACKUP" "$backup_path"
  fi

  mv "$tmp_file" "$target_path"
  sdd_log "UPDATED" "$target_path"
  return 0
}

sdd_targets_for_adapter() {
  adapter_name="$1"
  case "$adapter_name" in
    agents)
      printf "%s\n" "templates/adapters/AGENTS.md|AGENTS.md"
      ;;
    claude)
      printf "%s\n" "templates/adapters/CLAUDE.md|CLAUDE.md"
      ;;
    gemini)
      printf "%s\n" "templates/adapters/GEMINI.md|GEMINI.md"
      ;;
    opencode)
      printf "%s\n" "templates/opencode/sdd-orchestrator.md|examples/opencode/sdd-orchestrator.md"
      printf "%s\n" "templates/opencode/commands/sdd-explore.md|examples/opencode/commands/sdd-explore.md"
      printf "%s\n" "templates/opencode/commands/sdd-new.md|examples/opencode/commands/sdd-new.md"
      printf "%s\n" "templates/opencode/commands/sdd-continue.md|examples/opencode/commands/sdd-continue.md"
      printf "%s\n" "templates/opencode/commands/sdd-ff.md|examples/opencode/commands/sdd-ff.md"
      printf "%s\n" "templates/opencode/commands/sdd-apply.md|examples/opencode/commands/sdd-apply.md"
      printf "%s\n" "templates/opencode/commands/sdd-verify.md|examples/opencode/commands/sdd-verify.md"
      ;;
    *)
      return 1
      ;;
  esac
}

sdd_validate_adapters() {
  adapter_list="$1"
  if [ -z "$adapter_list" ]; then
    sdd_die "Adapter list cannot be empty"
  fi

  parsed=$(printf "%s" "$adapter_list" | tr ',' ' ')
  for adapter in $parsed; do
    case "$adapter" in
      agents|claude|gemini|opencode)
        ;;
      *)
        sdd_die "Unknown adapter '$adapter'. Allowed: agents,claude,gemini,opencode"
        ;;
    esac
  done
  printf "%s\n" "$parsed"
}
