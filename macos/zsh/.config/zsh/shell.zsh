# Emacs-style line editing like bash (zsh would pick vi mode because EDITOR=nvim)
bindkey -e

# Allow `# comments` on the command line, like bash
setopt interactive_comments

# History control
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=$HISTSIZE
setopt share_history       # Share history between open shells
setopt hist_ignore_space   # Skip commands starting with a space
setopt hist_ignore_dups    # Skip repeated commands

# Autocompletion (including completions installed by Homebrew)
fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" $fpath)
autoload -Uz compinit
mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Ignore case
zstyle ':completion:*' menu select                         # Tab cycles through candidates in a menu
zstyle ':completion:*' list-colors ''                      # Color candidates like `ls`
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete         # Shift+Tab goes backwards

# Arrow keys match what you've typed so far against your command history
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
