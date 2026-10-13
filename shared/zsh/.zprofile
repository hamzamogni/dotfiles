# Login shell setup (Ghostty, tmux and the GNOME session all start login shells)
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $brew ]] && eval "$("$brew" shellenv zsh)" && break
done
unset brew

# zsh skips the sh login files, where Ubuntu puts /snap/bin, the locale and machine-specific exports
if [[ $OSTYPE == linux* ]]; then
  [[ -r /etc/profile ]] && emulate sh -c '. /etc/profile'
  [[ -r $HOME/.profile ]] && emulate sh -c '. "$HOME/.profile"'
fi
