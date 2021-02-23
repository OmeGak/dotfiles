tmx() {
    tmuxp load -d "$1" && tmux -CC attach -t "$1"
}
