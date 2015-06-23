export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$ZSH/bin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

if [[ "$(uname -s)" == "Linux" ]]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
fi

# Keep path clean from duplicates
typeset -U PATH
typeset -U MANPATH
