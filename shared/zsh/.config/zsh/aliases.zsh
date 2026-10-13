# File system
if (( $+commands[eza] )); then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'
sff() {
  if (( $# == 0 )); then echo "Usage: sff <destination> (e.g. sff host:/tmp/)"; return 1; fi
  local file
  file=$(find . -type f -exec stat -f '%m%t%N' {} + | sort -rn | cut -f2- | ff) && [[ -n $file ]] && scp "$file" "$1"
}

if (( $+commands[zoxide] )); then
  alias cd="zd"
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@"; then
        echo "Error: Directory not found"
        return 1
      fi

      printf "\U000F17A9 "
      pwd
    fi
  }
  compdef zd=cd
fi

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias d='podman'
alias t='tmux attach || tmux new -s Work'
alias ts='tmux-sessionizer'
n() { if (( $# == 0 )); then command nvim . ; else command nvim "$@"; fi; }

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
