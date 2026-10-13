#!/usr/bin/env bash
# GNOME settings, close to Omarchy and the Mac's AeroSpace setup. Safe to re-run.
#
# To find the key behind any setting:
#   gsettings list-recursively > before.txt; (change it in Settings); gsettings list-recursively > after.txt; diff before.txt after.txt

set -euo pipefail

cd "$(dirname "$0")"

WORKSPACES=5

# Caps Lock: hold = Super, tap = Escape (see keyd/default.conf)
sudo install -Dm644 keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable keyd
sudo systemctl restart keyd

# Keyboard: fast key repeat, like the Mac
gsettings set org.gnome.desktop.peripherals.keyboard delay 225
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30

# Touchpad: tap to click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Workspaces: a fixed set, so Super+<number> always has somewhere to go
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces "$WORKSPACES"

# Super+<number> goes to a workspace and Super+Shift+<number> moves the window there.
# GNOME and Ubuntu Dock use these keys to open dock apps, so turn those off first.
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
for i in $(seq 1 9); do
  gsettings set org.gnome.shell.keybindings "switch-to-application-$i" "[]"
done
for i in $(seq 1 "$WORKSPACES"); do
  gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$i']"
  gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-$i" "['<Super><Shift>$i']"
done

# Super+Tab cycles workspaces like on the Mac. Alt+Tab still switches windows.
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super><Shift>Tab']"

# Super+A is Caps Lock + A, which Ghostty turns into the tmux prefix. GNOME uses it for the app grid.
gsettings set org.gnome.shell.keybindings toggle-application-view "[]"

# Windows
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w', '<Alt>F4']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"

# App shortcuts. Each one is a GNOME custom shortcut under .../custom-keybindings/<id>/.
shortcut() {
  local id=$1 name=$2 command=$3 binding=$4
  local list_key="org.gnome.settings-daemon.plugins.media-keys"
  local path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$id/"
  local schema="$list_key.custom-keybinding:$path"
  gsettings set "$schema" name "$name"
  gsettings set "$schema" command "$command"
  gsettings set "$schema" binding "$binding"

  local list
  list="$(gsettings get "$list_key" custom-keybindings)"
  if [[ $list != *"'$path'"* ]]; then
    if [[ $list == *"[]" ]]; then list="['$path']"; else list="${list%]}, '$path']"; fi
    gsettings set "$list_key" custom-keybindings "$list"
  fi
}
shortcut dotfiles-terminal "Terminal" "xdg-terminal-exec" "<Super>Return"
shortcut dotfiles-files "Files" "nautilus --new-window" "<Super><Shift>f"
shortcut dotfiles-appearance "Toggle light and dark mode" "$HOME/.local/bin/toggle-appearance" "<Super><Shift>t"

echo "Applied GNOME settings. Some take effect after logging out and back in."
