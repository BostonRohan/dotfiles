#!/usr/bin/env bash
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSHRC_PATH="$HOME/.zshrc"

ok() { echo "[OK]   $*"; }
warn() { echo "[WARN] $*"; }
fail() { echo "[FAIL] $*"; FAILED=1; }

FAILED=0

echo "Checking AI profile setup..."

check_zshrc_pattern() {
  local label="$1"
  local pattern="$2"

  if [[ ! -f "$ZSHRC_PATH" ]]; then
    fail "Missing $ZSHRC_PATH"
    return
  fi

  if rg -q "$pattern" "$ZSHRC_PATH"; then
    ok "$label configured"
  else
    fail "$label missing or different in $ZSHRC_PATH"
  fi
}

check_link() {
  local label="$1"
  local path="$2"
  local expected_target="$3"

  if [[ ! -L "$path" ]]; then
    fail "${label}: ${path} is not a symlink"
    return
  fi

  local actual_target
  actual_target="$(readlink "$path")"
  if [[ "$actual_target" == "$expected_target" ]]; then
    ok "${label}: symlink target is correct"
  else
    fail "${label}: expected -> ${expected_target}, found -> ${actual_target}"
  fi
}

check_codex_status() {
  local label="$1"
  local codex_home="$2"

  if [[ ! -d "$codex_home" ]]; then
    fail "${label}: missing directory ${codex_home}"
    return
  fi

  if output="$(CODEX_HOME="$codex_home" codex login status 2>&1)"; then
    ok "${label}: $(echo "$output" | tr '\n' ' ' | sed 's/  */ /g')"
  else
    warn "${label}: $(echo "$output" | tr '\n' ' ' | sed 's/  */ /g')"
  fi
}

check_claude_status() {
  local label="$1"
  local claude_dir="$2"

  if [[ ! -d "$claude_dir" ]]; then
    fail "${label}: missing directory ${claude_dir}"
    return
  fi

  if [[ ! -f "$claude_dir/.claude.json" ]]; then
    warn "${label}: not configured (${claude_dir}/.claude.json missing)"
    return
  fi

  if output="$(CLAUDE_CONFIG_DIR="$claude_dir" claude auth status </dev/null 2>&1)"; then
    ok "${label}: $(echo "$output" | tr '\n' ' ' | sed 's/  */ /g')"
  else
    warn "${label}: $(echo "$output" | tr '\n' ' ' | sed 's/  */ /g')"
  fi
}

check_zshrc_pattern "codex function" '^codex\(\) \{$'
check_zshrc_pattern "ec-codex function" '^ec-codex\(\) \{$'
check_zshrc_pattern "claude function" '^claude\(\) \{$'
check_zshrc_pattern "ec-claude function" '^ec-claude\(\) \{$'
check_zshrc_pattern "codex CODEX_HOME mapping" 'CODEX_HOME="\$HOME/\.codex" command codex'
check_zshrc_pattern "ec-codex CODEX_HOME mapping" 'CODEX_HOME="\$HOME/\.ec-codex" command codex'
check_zshrc_pattern "claude CLAUDE_CONFIG_DIR mapping" 'CLAUDE_CONFIG_DIR="\$HOME/\.claude" command claude'
check_zshrc_pattern "ec-claude CLAUDE_CONFIG_DIR mapping" 'CLAUDE_CONFIG_DIR="\$HOME/\.ec-claude" command claude'

check_link "Codex default config" "$HOME/.codex/config.toml" "$DOTFILES_ROOT/.config/codex/profiles/personal/config.toml"
check_link "Codex EC config" "$HOME/.ec-codex/config.toml" "$DOTFILES_ROOT/.config/codex/profiles/work/config.toml"
check_link "Claude default settings" "$HOME/.claude/settings.json" "$DOTFILES_ROOT/.config/claude/profiles/personal/settings.json"
check_link "Claude EC settings" "$HOME/.ec-claude/settings.json" "$DOTFILES_ROOT/.config/claude/profiles/work/settings.json"

check_codex_status "Codex default" "$HOME/.codex"
check_codex_status "Codex EC" "$HOME/.ec-codex"
check_claude_status "Claude default" "$HOME/.claude"
check_claude_status "Claude EC" "$HOME/.ec-claude"

if [[ "$FAILED" -ne 0 ]]; then
  echo
  echo "Validation failed."
  exit 1
fi

echo
echo "Validation passed."
