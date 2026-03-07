#!/usr/bin/env bash
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$HOME/.codex" "$HOME/.ec-codex" "$HOME/.claude" "$HOME/.ec-claude"

link_with_backup() {
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "Backed up existing file: $dst -> $backup"
  fi

  ln -sfn "$src" "$dst"
}

link_with_backup "$DOTFILES_ROOT/.config/codex/profiles/personal/config.toml" "$HOME/.codex/config.toml"
link_with_backup "$DOTFILES_ROOT/.config/codex/profiles/work/config.toml" "$HOME/.ec-codex/config.toml"
link_with_backup "$DOTFILES_ROOT/.config/claude/profiles/personal/settings.json" "$HOME/.claude/settings.json"
link_with_backup "$DOTFILES_ROOT/.config/claude/profiles/work/settings.json" "$HOME/.ec-claude/settings.json"

cat <<MSG
AI profile bootstrap complete.

Codex profiles:
- default: $HOME/.codex (use: codex)
- ec:      $HOME/.ec-codex (use: ec-codex)

Claude profiles:
- default: $HOME/.claude (use: claude)
- ec:      $HOME/.ec-claude (use: ec-claude)

Next steps:
1) source ~/.zshrc
2) codex login status
3) ec-codex login status
4) claude
5) ec-claude
MSG
