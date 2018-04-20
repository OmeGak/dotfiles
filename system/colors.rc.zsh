# Colorize unix tools all over the place
if (( $+commands[grc] )); then
  source $BREWDIR/etc/grc.bashrc
fi

# Colorize ls
export CLICOLOR=true
export LSCOLORS='ExGxFxdxCxDxDxBxBxExEx'

# Colorize grep
alias grep="grep --color=auto"
