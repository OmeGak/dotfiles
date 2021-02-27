alias reload!='. ~/.zshrc'


# -- Directory navigation ------------------------------------------------------

alias ..="cd .."
alias -- -='pushd'              # Switch to most recent dir
alias -- --='popd 2> /dev/null' # Go back in history

# Show current directory and directory history
SLASH='pwd | sed "s:^$HOME:~:"'
alias /="${SLASH}"
alias //="dirs -v | tail -n +2 | tac; echo \"0\t\$(${SLASH})\""
unset SLASH

# List cd linksc
alias cdl="ls -1 ~/.cdlinks"

# -- Directory listing ---------------------------------------------------------

LS_ARGS="--color --group-directories-first -FH"
[[ $(which gls) ]] && LS="gls ${LS_ARGS}" || LS="ls ${LS_ARGS}"
alias ls="$LS"
alias ll="$LS -lh"
alias la="$LS -lhA"
unset LS_ARGS
unset LS

if [[ $(which exa) ]]; then
  EXA="exa --group-directories-first --git --time-style=long-iso -F"
  alias ls="${EXA}"
  alias ll="${EXA} -l"
  alias la="${EXA} -la"
  alias tree="${EXA} --tree"
  unset EXA
fi
