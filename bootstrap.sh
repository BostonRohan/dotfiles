#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Bootstrapping dotfiles from ${ROOT_DIR}"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required but was not found."
  echo "Install it first: https://brew.sh/"
  exit 1
fi

echo "==> Installing packages"
brew bundle --file "${ROOT_DIR}/Brewfile"

unlink_legacy_symlink() {
  local path="$1"
  local target
  local resolved_target

  if [ -L "$path" ]; then
    target="$(readlink "$path")"
    if [[ "$target" = /* ]]; then
      resolved_target="$target"
    else
      resolved_target="$(cd "$(dirname "$path")" && pwd -P)/$target"
    fi
    case "$resolved_target" in
      "$ROOT_DIR"/*)
        rm "$path"
        ;;
    esac
  fi
}

unlink_legacy_symlink "${HOME}/.zshrc"
unlink_legacy_symlink "${HOME}/.config"
unlink_legacy_symlink "${HOME}/.warp"

echo "==> Stowing dotfiles"
stow --ignore='\.DS_Store$' -d "${ROOT_DIR}" -t "${HOME}" \
  zsh \
  tmux \
  lazygit \
  ghostty \
  sketchybar \
  aerospace \
  spotify-player \
  nvim \
  warp \
  codex \
  claude \
  gh \
  git

echo "==> Done"
echo "Restart your shell or run: exec zsh"
