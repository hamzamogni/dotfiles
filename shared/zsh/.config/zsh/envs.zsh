# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# Use the terminal's palette, so bat follows the light/dark theme
export BAT_THEME=ansi

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Use the terminal's 16 colors, so fzf follows the light/dark theme
export FZF_DEFAULT_OPTS="--color=16"

typeset -U path
path+=("$HOME/.local/bin")
