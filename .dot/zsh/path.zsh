export PATH="$DOT/bin:$DOT/.dot/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

if [[ "$OS" == "Linux" ]]; then
  PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
  MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
fi

# Keep path clean from duplicates
typeset -U PATH
typeset -U MANPATH
