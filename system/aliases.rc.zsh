# places
alias ..="cd .."
alias code="cd $HOME/Code"

# ls
[[ $(which gls) ]] && LS="gls" || LS="ls"
alias ls="$LS -FH --color"
alias ll="$LS -lhH --group-directories-first --color"
alias lla="$LS -lhAH --group-directories-first --color"
unset LS

# path
alias path='echo $PATH | tr : "\n"'

# fattest directories
alias fatd="gdu -sh *(/D) | gsort -rh | head -10"
alias fatdr="gdu -Sh | gsort -rh | head -10"

# Linux fixes
if [[ "$OS" == "Linux" ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi

# macOS fixes
if [[ "$OS" == "Darwin" ]]; then
  alias tac='tail -r'
fi


# -- Snippets ------------------------------------------------------------------

# Download website for full offline navigation
# Source: http://www.kossboss.com/linux---wget-full-website
if [[ $(which wget) ]]; then
  alias wget-full="wget --recursive --no-parent --page-requisites --adjust-extension --convert-links --timestamping \
                        --user-agent=mozilla --limit-rate=200k --random-wait --execute robots=off"
fi

if [[ $(which xkcdpass) ]]; then
  alias xkcdpass="xkcdpass --interactive --numwords=4 --valid-chars='[a-z]' --max=8 --delimiter='-'"
fi
