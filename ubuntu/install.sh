#!/usr/bin/env bash
# Set up this Ubuntu machine from the dotfiles in this folder. Safe to re-run.
#
# Usage: ./install.sh               Install packages, link dotfiles and switch the login shell to zsh
#        ./install.sh --defaults    Also apply GNOME settings from defaults.sh
#        ./install.sh --link-only   Only link dotfiles

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

if ! grep -qx 'ID=ubuntu' /etc/os-release; then
  echo "This installer is for Ubuntu. Use macos/install.sh on a Mac." >&2
  exit 1
fi

if ! $link_only; then
  sudo apt-get update
  sed 's/#.*//' packages.txt | xargs sudo apt-get install -y

  # Ubuntu ships these as batcat and fdfind, because other packages already own the short names
  mkdir -p "$HOME/.local/bin"
  for name in bat:batcat fd:fdfind; do
    short="${name%%:*}"
    if [[ ! -e /usr/bin/$short && ! -e $HOME/.local/bin/$short && ! -L $HOME/.local/bin/$short ]]; then
      ln -s "/usr/bin/${name#*:}" "$HOME/.local/bin/$short"
    fi
  done

  if [[ ! -x $HOME/.local/bin/mise ]] && ! command -v mise &>/dev/null; then
    curl -fsSL https://mise.run | MISE_QUIET=1 sh
  fi

  if ! rustup show active-toolchain &>/dev/null; then
    rustup default stable
  fi
fi

"$REPO/scripts/link.sh" "$REPO/shared"
"$REPO/scripts/link.sh" "$DOTFILES" bin terminal ghostty tmux

# A running tmux server reads its config only when it starts
tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || true

if ! $link_only; then
  "$REPO/scripts/install-nvim-plugins.sh"

  zsh_path="$(command -v zsh)"
  if [[ "$(getent passwd "$(id -un)" | cut -d: -f7)" != "$zsh_path" ]]; then
    echo "Switching your login shell to zsh. chsh asks for your password."
    chsh -s "$zsh_path"
  fi
fi

if $defaults; then
  "$DOTFILES/defaults.sh"
fi

cat <<DONE

Done. Next steps:
  - Log out and back in, so GNOME starts with zsh and the new settings.
DONE
