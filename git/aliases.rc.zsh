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
