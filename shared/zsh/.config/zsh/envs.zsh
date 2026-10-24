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

# Android SDK, where Android Studio installs it on macOS
if [[ -d $HOME/Library/Android/sdk ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path=("$ANDROID_HOME/platform-tools" "$ANDROID_HOME/cmdline-tools/latest/bin" "$ANDROID_HOME/emulator" $path)
fi

export GH_TOKEN=$(gh auth token)
