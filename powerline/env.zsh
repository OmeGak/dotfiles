export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

REPO_ROOT=$(syspip show powerline-status | grep Location: | cut -d ' ' -f 2-)
# export XDG_CONFIG_HOME=$DOT
export POWERLINE_DIR="$REPO_ROOT/powerline"
unset REPO_ROOT

# powerline-daemon -q
