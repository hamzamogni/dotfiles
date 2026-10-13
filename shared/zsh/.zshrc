# Omarchy's bash defaults, ported to zsh. Edit the pieces in ~/.config/zsh/.
for file in envs shell aliases functions init; do
  source "$XDG_CONFIG_HOME/zsh/$file.zsh"
done

# Machine-specific or secret settings that should not be committed
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Pi
export PATH="$HOME/.local/bin:$PATH"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$PATH"
