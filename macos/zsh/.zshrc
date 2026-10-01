# Omarchy's bash defaults, ported to zsh. Edit the pieces in ~/.config/zsh/.
for file in envs shell aliases functions init; do
  source "$XDG_CONFIG_HOME/zsh/$file.zsh"
done

# Machine-specific or secret settings that should not be committed
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
