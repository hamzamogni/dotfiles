# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

# Create a new worktree and branch from within current git directory.
ga() {
  if [[ -z "$1" ]]; then
    echo "Usage: ga [branch name]"
    return 1
  fi

  local branch="$1"
  local base="$(basename "$PWD")"
  local wt_path="../${base}--${branch}"

  git worktree add -b "$branch" "$wt_path" || return 1
  cd "$wt_path"
}

# Remove the current worktree and its branch. Refuses uncommitted work, unmerged branches
# and worktrees that T3 Code manages.
gd() {
  local worktree branch main
  worktree="$(git rev-parse --show-toplevel)" || return 1
  branch="$(git branch --show-current)"
  main="$(git worktree list --porcelain | sed -n '1s/^worktree //p')"

  if [[ $worktree == "$main" ]]; then
    echo "gd: $worktree is the main checkout, not a worktree"
    return 1
  fi
  if [[ $worktree == "$HOME/.t3/"* ]]; then
    echo "gd: T3 Code manages $worktree. Remove it from T3 Code."
    return 1
  fi
  if [[ -n "$(git status --porcelain)" ]]; then
    echo "gd: $worktree has uncommitted changes"
    return 1
  fi

  gum confirm "Remove worktree $worktree${branch:+ and branch $branch}?" || return 0
  cd "$main" || return 1
  git worktree remove "$worktree" || return 1
  [[ -n $branch ]] && git branch -d "$branch"
}

# SSH Port Forwarding Functions
fip() {
  (( $# < 2 )) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
  local host="$1"
  shift
  for port in "$@"; do
    ssh -f -N -L "${port}:localhost:${port}" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}

dip() {
  (( $# == 0 )) && echo "Usage: dip <port1> [port2] ..." && return 1
  for port in "$@"; do
    pkill -f "ssh.*-L ${port}:localhost:${port}" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
  done
}

lip() {
  pgrep -lf "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}
