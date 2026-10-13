#!/usr/bin/env bash
# Link stow packages into ~. Safe to re-run.
#
# Usage: scripts/link.sh <stow-dir> [package...]   (no packages: every package in <stow-dir>)
#
# Anything in the way is moved to ~/.dotfiles-backup/<date>/. Links into this repo left by an
# older layout are replaced, and files Git doesn't track behind them (like ~/.config/git/local)
# are moved to the same place under ~.

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd -P)"
STOW_DIR="$(cd "$1" && pwd -P)"
shift
if (( $# == 0 )); then
  set -- $(cd "$STOW_DIR" && ls -d */ | tr -d /)
fi

# Packages whose folders must stay real in ~, so other files can sit next to the linked ones:
# git's ~/.config/git/local, installers writing to ~/.local/bin, per-OS os.ghostty and os.conf.
NO_FOLDING=" git bin ghostty tmux "

BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
REPO_TAIL="$(basename "$(dirname "$DOTFILES")")/$(basename "$DOTFILES")"
old_dirs=()
old_targets=()

backup() {
  mkdir -p "$(dirname "$BACKUP_DIR/$1")"
  mv "$HOME/$1" "$BACKUP_DIR/$1"
  echo "Backed up ~/$1 to $BACKUP_DIR"
}

folds() { [[ $NO_FOLDING != *" $1 "* ]]; }

# Remove a link into this repo unless it's the link stow would make for <package>.
replace_old_link() {
  local relative=$1 package=$2 path="$HOME/$1" resolved
  [[ -L $path && "$(readlink "$path")" == *"$REPO_TAIL/"* ]] || return 0
  resolved="$(realpath "$path" 2>/dev/null)" || resolved=""
  if [[ $resolved == "$STOW_DIR/$package/$relative" ]] && { folds "$package" || [[ ! -d $resolved ]]; }; then
    return 0
  fi
  rm "$path"
  echo "Removed old link ~/$relative"
  if [[ -d $resolved ]]; then
    old_dirs+=("$resolved")
    old_targets+=("$relative")
  fi
}

move_untracked() {
  local old=$1 relative=$2 file dest
  while IFS= read -r -d '' file; do
    file="$DOTFILES/$file"
    dest="$HOME/$relative/${file#"$old"/}"
    [[ -e $dest || -L $dest ]] && continue
    mkdir -p "$(dirname "$dest")"
    mv "$file" "$dest"
    echo "Moved $file to $dest"
  done < <(git -C "$DOTFILES" ls-files --others -z -- "$old")
  find "$old" -depth -type d -empty -delete 2>/dev/null || true
  rmdir -p "$(dirname "$old")" 2>/dev/null || true
}

for package in "$@"; do
  # Each ~/.config/<tool> folder of a folding package should be a single link to this repo, so
  # apps that rewrite their config (like Karabiner) write here. Move real folders out of the way.
  if folds "$package"; then
    for dir in "$STOW_DIR/$package"/.config/*/; do
      [[ -d $dir ]] || continue
      relative="${dir#"$STOW_DIR/$package"/}"
      relative="${relative%/}"
      replace_old_link "$relative" "$package"
      if [[ -d "$HOME/$relative" && ! -L "$HOME/$relative" ]]; then
        backup "$relative"
      fi
    done
  fi

  while IFS= read -r -d '' file; do
    relative="${file#"$package"/}"
    prefix=""
    IFS=/ read -ra parts <<<"$(dirname "$relative")"
    for part in "${parts[@]}"; do
      [[ $part == . ]] && continue
      prefix="${prefix:+$prefix/}$part"
      replace_old_link "$prefix" "$package"
    done
    replace_old_link "$relative" "$package"

    # Move files that would block stow out of the way, e.g. a default ~/.zprofile
    target="$HOME/$relative"
    if [[ -e $target || -L $target ]] && [[ "$(realpath "$target" 2>/dev/null)" != "$STOW_DIR/$file" ]]; then
      backup "$relative"
    fi
  done < <(cd "$STOW_DIR" && find "$package" \( -type f -o -type l \) -print0)
done

folding=()
flat=()
for package in "$@"; do
  if folds "$package"; then folding+=("$package"); else flat+=("$package"); fi
done

mkdir -p "$HOME/.config"
if (( ${#folding[@]} )); then
  stow --dir="$STOW_DIR" --target="$HOME" --restow "${folding[@]}"
fi
if (( ${#flat[@]} )); then
  stow --dir="$STOW_DIR" --target="$HOME" --restow --no-folding "${flat[@]}"
fi
echo "Linked from $(basename "$STOW_DIR"): $*"

for (( i = 0; i < ${#old_dirs[@]}; i++ )); do
  move_untracked "${old_dirs[$i]}" "${old_targets[$i]}"
done
