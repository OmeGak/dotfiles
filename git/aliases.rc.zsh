# Use `hub` as git wrapper
if exists hub; then
  alias git='hub'
fi

alias gl="git lg"
alias gc="git commit"
alias gs="git status"

# Allow quickly going back to the root of the repo
alias cdroot="cd $(git root)"
