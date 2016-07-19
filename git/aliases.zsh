# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] )); then
  alias git=${hub_path}
fi

alias gl="git lg"
alias gc="git commit"
alias gd="git diff"
alias gd+="git diff-blame"
alias gs="git status"
