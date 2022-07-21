# Use `hub` as git wrapper
if (( $+commands[hub] )); then
  alias git='hub'
fi

alias gl="git lg"
alias gc="git commit"
alias gs="git status"
