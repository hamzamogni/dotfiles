# Omarchy's bash defaults, ported to zsh. Edit the pieces in ~/.config/zsh/.
for file in envs shell aliases functions init; do
  source "$XDG_CONFIG_HOME/zsh/$file.zsh"
done

# Machine-specific or secret settings that should not be committed
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export PATH=$PATH:$HOME/go/bin
export PATH="$HOME/.cargo/bin:$PATH"
