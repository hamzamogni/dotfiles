# Loaded by every zsh, including non-interactive ones. Keep it tiny.

# Make CLI tools (lazygit, btop, ...) use ~/.config instead of ~/Library/Application Support
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
