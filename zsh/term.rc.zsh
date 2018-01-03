TERMINFO_DIR="/usr/share/terminfo"
[[ "$OS" == "Linux" ]] && TERMINFO_DIR="/lib/terminfo"

# Always use screen on tmux
[[ -z $TMUX ]] && TERM_TYPE='xterm' || TERM_TYPE='screen'

# Apply 256 only if available
if [ ! -z $TERMINFO_DIR/**/$TERM_TYPE-256color(N) ]; then
  TERM_COLOR='-256color'
fi

export TERM="${TERM_TYPE}${TERM_COLOR}"
unset TERMINFO_DIR TERM_TYPE TERM_COLOR
