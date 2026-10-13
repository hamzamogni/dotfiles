#!/usr/bin/env bash
# Install LazyVim's plugins at the commits in lazy-lock.json. Does nothing once plugins are installed.
#
# lazy.nvim installs in two passes and rewrites the lockfile after the first one, so LazyVim's own
# plugins come out at their newest commits. This puts the lockfile back and restores from it.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd -P)"
lock="$REPO/shared/nvim/.config/nvim/lazy-lock.json"

[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy ]] && exit 0
if ! git -C "$REPO" diff --quiet -- "$lock"; then
  echo "Skipping Neovim plugins: $lock has uncommitted changes." >&2
  exit 0
fi

echo "Installing Neovim plugins..."
nvim --headless +qa &>/dev/null
git -C "$REPO" checkout -- "$lock"
nvim --headless "+Lazy! restore" +qa &>/dev/null
if git -C "$REPO" diff --quiet -- "$lock"; then
  echo "Installed Neovim plugins from lazy-lock.json"
else
  echo "Warning: Neovim plugins don't match lazy-lock.json. Run :Lazy restore in Neovim." >&2
fi
