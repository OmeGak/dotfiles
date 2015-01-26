# Fixes colors in tmux
if [[ -z $TMUX ]]; then
    # may be xterm-256 depending on your distro
    if [ -e /usr/share/terminfo/x/xterm+256color ]; then
        export TERM='xterm-256color'
    else
        export TERM='xterm'
    fi
else
    if [ -e /usr/share/terminfo/s/screen-256color ]; then
        export TERM='screen-256color'
    else
        export TERM='screen'
    fi
fi
