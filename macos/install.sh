#!/usr/bin/env bash
# Set up this Mac from the dotfiles in this folder. Safe to re-run.
#
# Usage: ./install.sh               Install Homebrew packages and link dotfiles
#        ./install.sh --defaults    Also apply macOS settings from defaults.sh
#        ./install.sh --link-only   Only link dotfiles, skip Homebrew

set -euo pipefail

cd "$(dirname "$0")"
DOTFILES="$(pwd -P)"
REPO="$(dirname "$DOTFILES")"
export BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_only=false
defaults=false
for arg in "$@"; do
  case $arg in
    --link-only) link_only=true ;;
    --defaults) defaults=true ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

if ! $link_only; then
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x $brew ]] && eval "$("$brew" shellenv bash)" && break
  done

  brew bundle --file="$DOTFILES/Brewfile" || echo "Some Brewfile entries failed (Mac App Store apps need you to be signed in). Continuing."
fi

"$REPO/scripts/link.sh" "$REPO/shared"
"$REPO/scripts/link.sh" "$DOTFILES" aerospace karabiner bin

# A running tmux server reads its config only when it starts
tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || true

if ! $link_only; then
  "$REPO/scripts/install-nvim-plugins.sh"
fi

# Ghostty on macOS also reads this file, and it would override the linked config
ghostty_app_config="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
if [[ -s $ghostty_app_config ]]; then
  echo "Warning: $ghostty_app_config is not empty and overrides ~/.config/ghostty. Consider emptying it."
fi

if $defaults; then
  "$DOTFILES/defaults.sh"
fi

cat <<EOF

Done. Next steps:
  - Open a new Ghostty window to load the new shell config.
  - Set up containers: podman machine init && podman machine start
EOF
