TERMINFO_DIR="/usr/share/terminfo"
[[ "$(uname -s)" == "Linux" ]] && TERMINFO_DIR="/lib/terminfo"

# Fixes colors in tmux
if [[ -z $TMUX ]]; then
    # may be xterm-256 depending on your distro
    if [ -e $TERMINFO_DIR/x/xterm+256color ]; then
        export TERM='xterm-256color'
    else
        export TERM='xterm'
    fi
else
    if [ -e $TERMINFO_DIR/s/screen-256color ]; then
        export TERM='screen-256color'
    else
        export TERM='screen'
    fi
fi

unset TERMINFO_DIR
