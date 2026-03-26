# Use `hub` as git wrapper
if (( $+commands[hub] )); then
  alias git='hub'
fi

if (( $+commands[tig] )); then
  alias gll='tig'
  alias gss='tig status'
fi

alias gc="git commit"
alias gl="git lg"
alias gs="git status"

# Change directory to root of the Git repository
cdr() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    cd "$(git rev-parse --show-toplevel)"
  else
    echo "Not inside a git repository."
  fi
}
