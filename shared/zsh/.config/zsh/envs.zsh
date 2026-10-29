# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# Use the terminal's palette, so bat follows the light/dark theme
export BAT_THEME=ansi

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Use the terminal's 16 colors, so fzf follows the light/dark theme: gray text and lines, blue
# for matches and the current line, no background behind the current line
export FZF_DEFAULT_OPTS="--color=16,bg+:-1,gutter:-1,fg+:-1:bold,hl:blue,hl+:blue,pointer:blue,marker:blue,prompt:blue,info:8,border:8,separator:8,scrollbar:8,spinner:blue --pointer=▌ --marker=▌"

# Android SDK, where Android Studio installs it on macOS
if [[ -d $HOME/Library/Android/sdk ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path=("$ANDROID_HOME/platform-tools" "$ANDROID_HOME/cmdline-tools/latest/bin" "$ANDROID_HOME/emulator" $path)
fi

export GH_TOKEN=$(gh auth token)
