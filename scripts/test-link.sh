#!/usr/bin/env bash
# Run link.sh against a throwaway copy of this repo and a throwaway HOME, including a home
# linked by the old macos/-only layout. Needs stow and git. Usage: scripts/test-link.sh

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
repo="$tmp/src/dotfiles"
export HOME="$tmp/home"
unset BACKUP_DIR
failures=0

check() {
  if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi
}
points_to() { [[ "$(realpath "$HOME/$1")" == "$repo/$2" ]]; }

mkdir -p "$repo" "$HOME/.config" "$HOME/.local"
git -C "$DOTFILES" ls-files -z --cached --others --exclude-standard |
  (cd "$DOTFILES" && tar --null -T - -cf -) | tar -xf - -C "$repo"
git -C "$repo" init -q && git -C "$repo" add -A &&
  git -C "$repo" -c user.name=test -c user.email=test@example.com commit -qm snapshot

echo "old" >"$HOME/.zshrc"
mkdir -p "$repo/macos/git/.config/git"
echo "[user] email = work@example.com" >"$repo/macos/git/.config/git/local"
ln -s ../../src/dotfiles/macos/git/.config/git "$HOME/.config/git"
ln -s ../../src/dotfiles/macos/nvim/.config/nvim "$HOME/.config/nvim"
ln -s ../../src/dotfiles/shared/ghostty/.config/ghostty "$HOME/.config/ghostty"
echo "binary" >"$repo/macos/bin/.local/bin/pi"
ln -s ../../src/dotfiles/macos/bin/.local/bin "$HOME/.local/bin"

link_all() {
  "$repo/scripts/link.sh" "$repo/shared"
  "$repo/scripts/link.sh" "$repo/macos" aerospace karabiner bin ghostty
  "$repo/scripts/link.sh" "$repo/ubuntu" bin terminal ghostty
}

link_all >/dev/null
check "~/.zshrc links to shared/zsh" 'points_to .zshrc shared/zsh/.zshrc'
check "the old ~/.zshrc is in the backup" 'grep -qx old "$HOME"/.dotfiles-backup/*/.zshrc'
check "~/.config/nvim is one link to shared/nvim" '[[ -L $HOME/.config/nvim ]] && points_to .config/nvim shared/nvim/.config/nvim'
check "~/.config/git is a real folder" '[[ -d $HOME/.config/git && ! -L $HOME/.config/git ]]'
check "~/.config/git/config links to shared/git" 'points_to .config/git/config shared/git/.config/git/config'
check "~/.config/git/local moved out of the repo" 'grep -q work@example.com "$HOME/.config/git/local" && [[ ! -L $HOME/.config/git/local ]]'
check "the old macos/git folder is gone" '[[ ! -e $repo/macos/git ]]'
check "~/.config/ghostty is a real folder" '[[ -d $HOME/.config/ghostty && ! -L $HOME/.config/ghostty ]]'
check "~/.config/ghostty has the shared config and a per-OS os.ghostty" '[[ -L $HOME/.config/ghostty/config.ghostty && -L $HOME/.config/ghostty/os.ghostty ]]'
check "~/.local/bin is a real folder" '[[ -d $HOME/.local/bin && ! -L $HOME/.local/bin ]]'
check "~/.local/bin/pi moved out of the repo" '[[ -f $HOME/.local/bin/pi && ! -L $HOME/.local/bin/pi ]]'
check "tmux-sessionizer links to shared/bin" 'points_to .local/bin/tmux-sessionizer shared/bin/.local/bin/tmux-sessionizer'
check "no broken links in ~" '[[ -z "$(find "$HOME" -xtype l)" ]]'
check "the repo has no stray files" '[[ -z "$(git -C "$repo" status --porcelain)" ]]'

backups="$(ls "$HOME/.dotfiles-backup")"
link_all >/dev/null
check "a second run makes no backup" '[[ "$(ls "$HOME/.dotfiles-backup")" == "$backups" ]]'
check "a second run leaves the repo clean" '[[ -z "$(git -C "$repo" status --porcelain)" ]]'

(( failures == 0 )) && echo "All checks passed." || { echo "$failures check(s) failed."; exit 1; }
