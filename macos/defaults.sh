#!/usr/bin/env bash
# macOS system settings. Safe to re-run.
#
# To find the key behind any setting:
#   defaults read > before.txt; (change it in System Settings); defaults read > after.txt; diff before.txt after.txt

set -euo pipefail

# Close System Settings so it doesn't overwrite these changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# Appearance: switch light/dark automatically (Ghostty and Neovim follow along)
defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true
# Accent color: blue (close to Catppuccin's accent)
defaults write -g AppleAccentColor -int 4

# Keyboard: fast key repeat, and holding a key repeats it instead of showing accents (needed for vim)
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false

# Text: no autocorrect, smart quotes or smart dashes (they break code)
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Dialogs: open save and print panels expanded
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# Trackpad: tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

# Finder: path bar and status bar, list view by default
# Keep "Show all filename extensions" off: Spotlight follows it and would list apps as "Name.app"
defaults write -g AppleShowAllExtensions -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Don't leave .DS_Store files on network and USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock: auto-hide quickly, minimize into the app icon, no recent apps
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false

# AeroSpace recommendations (https://nikitabobko.github.io/AeroSpace/guide)
# Turn off "Displays have separate Spaces": avoids focus and performance bugs with multiple monitors (needs a logout)
defaults write com.apple.spaces spans-displays -bool true
# Mission Control: group windows by app, otherwise AeroSpace's hidden windows make it show tiny thumbnails
defaults write com.apple.dock expose-group-apps -bool true

# Screenshots: PNG in ~/Pictures/Screenshots, no window shadow
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

killall Dock Finder SystemUIServer 2>/dev/null || true

echo "macOS settings applied. Log out and back in for keyboard, trackpad and Spaces changes to fully apply."
