# Use `hub` as git wrapper
if exists hub; then
  alias git='hub'
fi

alias gl="git lg"
alias gc="git commit"
alias gd="git diff"
alias gd+="git diff-blame"
alias gs="git status"