#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Bootstrapping dotfiles from ${ROOT_DIR}"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required but was not found."
  echo "Install it first: https://brew.sh/"
  exit 1
fi

# ---------------------------------------------------------------------------
# Toolchains installed OUTSIDE Homebrew (version managers + native installers).
# Done BEFORE brew bundle so node is on PATH for the npm global below.
# ---------------------------------------------------------------------------
NODE_VERSIONS=("20.11.0" "22.13.1" "24.14.0")
DEFAULT_NODE="20.11.0"

echo "==> nvm + node"
export NVM_DIR="${HOME}/.nvm"
if [ ! -s "${NVM_DIR}/nvm.sh" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
# shellcheck disable=SC1091
\. "${NVM_DIR}/nvm.sh"
for v in "${NODE_VERSIONS[@]}"; do
  nvm install "$v"
done
nvm alias default "${DEFAULT_NODE}"
nvm use default

echo "==> pnpm (via corepack)"
corepack enable >/dev/null 2>&1 || true
corepack prepare pnpm@latest --activate >/dev/null 2>&1 || true

echo "==> rust (rustup)"
if ! command -v rustc >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
fi
# shellcheck disable=SC1091
[ -s "${HOME}/.cargo/env" ] && \. "${HOME}/.cargo/env"

echo "==> Claude Code (native installer)"
if ! command -v claude >/dev/null 2>&1 && [ ! -x "${HOME}/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

echo "==> gemini-cli (npm global on default node)"
# Official channel. If you ever change the default node, re-run this line
# (or: nvm reinstall-packages <old-version>).
npm install -g @google/gemini-cli

# ---------------------------------------------------------------------------
# Homebrew packages
# ---------------------------------------------------------------------------
echo "==> Installing brew packages"
brew bundle --file "${ROOT_DIR}/Brewfile"

# ---------------------------------------------------------------------------
# Symlink configs with stow
# ---------------------------------------------------------------------------
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
  sketchybar \
  aerospace \
  nvim \
  warp \
  codex \
  claude \
  gh \
  git

echo "==> Done"
echo "Restart your shell or run: exec zsh"
