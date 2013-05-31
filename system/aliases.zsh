# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
    LS="gls"
else
    LS="ls"
fi

# places
alias ..="cd .."
alias code="cd $HOME/Code"

# ls
alias ls="$LS -F --color"
alias ll="$LS -lh --group-directories-first --color"
alias lla="$LS -lhA --group-directories-first --color"

# Linux fixes
if [[ "$(uname -s)" == "Linux" ]]
    then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
fi

unset LS