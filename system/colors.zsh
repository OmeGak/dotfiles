# Colorize unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] )); then
  source `brew --prefix`/etc/grc.bashrc
fi

# Colorize ls
export CLICOLOR=true
export LSCOLORS='ExGxFxdxCxDxDxBxBxExEx'

# Colorize grep
GREP_OPTIONS=' --color=auto'
alias grep="grep $GREP_OPTIONS"
unset GREP_OPTIONS
