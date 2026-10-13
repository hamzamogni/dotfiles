# Loaded by every zsh, including non-interactive ones. Keep it tiny.

# Make CLI tools (lazygit, btop, ...) use ~/.config instead of ~/Library/Application Support
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# User-installed tools and mise's shims, so non-interactive shells (ssh host <command>) find them too
typeset -U path
path=("$HOME/.local/bin" "$XDG_DATA_HOME/mise/shims" $path)

# Ubuntu's /etc/zsh/zshrc runs compinit too. shell.zsh runs it once with a cache file.
skip_global_compinit=1
