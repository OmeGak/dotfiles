alias cddot='cd $DOT'
alias reload!='. ~/.zshrc'

# Refresh history from file
alias histr='fc -RI'


# -- Directory stack navigation -----------------------------------------------

# Show dir current/history
alias /='pwd | sed "s:^$HOME:~:"'
alias //='dirs -v | tail -n +2 | tac'

# Switch to most recent dir
alias -- -='pushd'

# Go back in history
alias -- --='popd 2> /dev/null'
