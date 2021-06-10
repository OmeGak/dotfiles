export EDITOR='vim'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export QUOTING_STYLE=literal

# Colorization
export CLICOLOR=true
export LS_COLORS='ExGxFxdxCxDxDxBxBxExEx'
export GREP_OPTIONS='--color=auto'

# Set bat as the colorizing pager for man
# source: https://github.com/sharkdp/bat#man
export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
