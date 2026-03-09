#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

INSTALL_SCRIPT="$ROOT_DIR/scripts/sdd-install.sh"
UPDATE_SCRIPT="$ROOT_DIR/scripts/sdd-update.sh"
FIXTURES_DIR="$ROOT_DIR/examples/fixtures"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

PASS=0
FAIL=0

log_pass() {
  PASS=$((PASS + 1))
  printf "PASS: %s\n" "$1"
}

log_fail() {
  FAIL=$((FAIL + 1))
  printf "FAIL: %s\n" "$1"
}

assert_file_exists() {
  file_path="$1"
  test_name="$2"
  if [ -f "$file_path" ]; then
    log_pass "$test_name"
  else
    log_fail "$test_name"
  fi
}

assert_contains() {
  file_path="$1"
  expected="$2"
  test_name="$3"
  if grep -Fq "$expected" "$file_path"; then
    log_pass "$test_name"
  else
    log_fail "$test_name"
  fi
}

assert_same_checksum() {
  before_sum="$1"
  after_sum="$2"
  test_name="$3"
  if [ "$before_sum" = "$after_sum" ]; then
    log_pass "$test_name"
  else
    log_fail "$test_name"
  fi
}

printf "Running SDD install/update smoke tests in %s\n" "$TMP_DIR"

# Scenario 1: Fresh install into empty fixture project.
cp -R "$FIXTURES_DIR/empty-project" "$TMP_DIR/empty-project"
"$INSTALL_SCRIPT" --project "$TMP_DIR/empty-project" --adapters agents,claude,gemini,opencode --yes --no-backup >/dev/null

assert_file_exists "$TMP_DIR/empty-project/AGENTS.md" "fresh install creates AGENTS.md"
assert_file_exists "$TMP_DIR/empty-project/CLAUDE.md" "fresh install creates CLAUDE.md"
assert_file_exists "$TMP_DIR/empty-project/GEMINI.md" "fresh install creates GEMINI.md"
assert_file_exists "$TMP_DIR/empty-project/examples/opencode/commands/sdd-new.md" "fresh install creates OpenCode command files"

# Scenario 2: Re-run install idempotency.
before_agents=$(sha256sum "$TMP_DIR/empty-project/AGENTS.md" | awk '{print $1}')
"$INSTALL_SCRIPT" --project "$TMP_DIR/empty-project" --adapters agents --yes --no-backup >/dev/null
after_agents=$(sha256sum "$TMP_DIR/empty-project/AGENTS.md" | awk '{print $1}')
assert_same_checksum "$before_agents" "$after_agents" "re-run install is idempotent for AGENTS.md"

# Scenario 3: Update from older stamped blocks while preserving custom content.
cp -R "$FIXTURES_DIR/existing-managed" "$TMP_DIR/existing-managed"
"$UPDATE_SCRIPT" --project "$TMP_DIR/existing-managed" --adapters agents --no-backup >/dev/null

assert_contains "$TMP_DIR/existing-managed/AGENTS.md" "<!-- SDD:BEGIN adapter=AGENTS version=1 -->" "update upgrades managed block version"
assert_contains "$TMP_DIR/existing-managed/AGENTS.md" "This section is custom content and must be preserved." "update preserves custom content before block"
assert_contains "$TMP_DIR/existing-managed/AGENTS.md" "Footer notes must stay untouched." "update preserves custom content after block"

# Scenario 4: Existing custom file without markers should not be overwritten.
cp -R "$FIXTURES_DIR/custom-no-markers" "$TMP_DIR/custom-no-markers"
before_custom=$(sha256sum "$TMP_DIR/custom-no-markers/AGENTS.md" | awk '{print $1}')
"$INSTALL_SCRIPT" --project "$TMP_DIR/custom-no-markers" --adapters agents --yes --no-backup >/dev/null
after_custom=$(sha256sum "$TMP_DIR/custom-no-markers/AGENTS.md" | awk '{print $1}')
assert_same_checksum "$before_custom" "$after_custom" "install preserves custom unmarked file without --force"

# Scenario 5: Dry-run mode is non-destructive.
before_dry=$(sha256sum "$TMP_DIR/custom-no-markers/AGENTS.md" | awk '{print $1}')
"$INSTALL_SCRIPT" --project "$TMP_DIR/custom-no-markers" --adapters agents --dry-run --yes --no-backup >/dev/null
"$UPDATE_SCRIPT" --project "$TMP_DIR/custom-no-markers" --adapters agents --dry-run --no-backup >/dev/null
after_dry=$(sha256sum "$TMP_DIR/custom-no-markers/AGENTS.md" | awk '{print $1}')
assert_same_checksum "$before_dry" "$after_dry" "dry-run does not modify files"

printf "\nSummary: %s passed, %s failed\n" "$PASS" "$FAIL"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
