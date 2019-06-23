# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh --group-directories-first'
alias lf="ls -lp | grep '/'"
alias ..='cd ..;'


alias pbcopy="xclip -sel clip < "

# syntax: search $what $where
search_on() {
  find $2 -name .git -prune -o -type f -exec grep -Inr "$1" {} +
}
alias search=search_on
