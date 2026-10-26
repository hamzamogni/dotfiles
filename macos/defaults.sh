#!/usr/bin/env bash
# macOS system settings. Safe to re-run.
# Only what the terminal and editor need, plus a few window and Finder tweaks. Everything else
# (trackpad, Spaces, dialogs, accent color) is left at Apple's defaults.
#
# To find the key behind any setting:
#   defaults read > before.txt; (change it in System Settings); defaults read > after.txt; diff before.txt after.txt

set -euo pipefail

# Close System Settings so it doesn't overwrite these changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# Appearance: switch light/dark automatically (cmux, tmux and Neovim follow along)
defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true

# Keyboard: fast key repeat, and holding a key repeats it instead of showing accents (needed for vim)
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false

# Text: no autocorrect, smart quotes or smart dashes (they break code)
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Finder: path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Don't leave .DS_Store files on network and USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Windows: auto-hide the Dock, and double-clicking a title bar fills the whole screen
defaults write com.apple.dock autohide -bool true
defaults write -g AppleActionOnDoubleClick -string "Fill"
# Mission Control: group windows by app
defaults write com.apple.dock expose-group-apps -bool true

# Screenshots: save to ~/Pictures/Screenshots instead of the Desktop
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

killall Dock Finder SystemUIServer 2>/dev/null || true

echo "macOS settings applied. Log out and back in for the keyboard changes to fully apply."
