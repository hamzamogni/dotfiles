if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

if [[ ${TERM:-} != "dumb" ]] && (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Ctrl-R (history), Ctrl-T (files), Alt-C (directories)
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# Fish-style suggestions and syntax highlighting (highlighting must load last)
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  [[ -f "$HOMEBREW_PREFIX/share/$plugin/$plugin.zsh" ]] && source "$HOMEBREW_PREFIX/share/$plugin/$plugin.zsh"
done
unset plugin
