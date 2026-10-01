#!/usr/bin/env bash
# Set up this Mac from the dotfiles in this folder. Safe to re-run.
#
# Usage: ./install.sh              Install Homebrew packages and link dotfiles
#        ./install.sh --defaults   Also apply macOS settings from defaults.sh

set -euo pipefail

cd "$(dirname "$0")"
DOTFILES="$(pwd -P)"
PACKAGES=(zsh ghostty tmux nvim starship git btop bin)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv bash)"

brew bundle --file="$DOTFILES/Brewfile" || echo "Some Brewfile entries failed (Mac App Store apps need you to be signed in). Continuing."

# Move files that would block stow out of the way, e.g. a default ~/.zprofile
for package in "${PACKAGES[@]}"; do
  while IFS= read -r -d '' file; do
    relative="${file#"$package"/}"
    target="$HOME/$relative"

    if [[ -e $target || -L $target ]] && [[ "$(realpath "$target" 2>/dev/null)" != "$DOTFILES/$file" ]]; then
      mkdir -p "$(dirname "$BACKUP_DIR/$relative")"
      mv "$target" "$BACKUP_DIR/$relative"
      echo "Backed up ~/$relative to $BACKUP_DIR"
    fi
  done < <(find "$package" -type f -print0)
done

mkdir -p "$HOME/.config"
stow --restow --target="$HOME" "${PACKAGES[@]}"
echo "Linked: ${PACKAGES[*]}"

# Ghostty on macOS also reads this file, and it would override the linked config
ghostty_app_config="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
if [[ -s $ghostty_app_config ]]; then
  echo "Warning: $ghostty_app_config is not empty and overrides ~/.config/ghostty. Consider emptying it."
fi

if [[ ${1:-} == "--defaults" ]]; then
  "$DOTFILES/defaults.sh"
fi

cat <<EOF

Done. Next steps:
  - Open a new Ghostty window to load the new shell config.
  - Start Neovim once to let LazyVim install its plugins.
  - Set up containers: podman machine init && podman machine start
EOF
