# Load tmuxp session
tmx() {
  tmuxp load "$1"
}

# Launch tmux windows and tmuxp sessions on iterm
if [[ "$OS" == "Darwin" ]]; then
  alias itmux='tmux -CC'
  itmx() { tmuxp load -d "$1" && tmux -CC attach -t "$2:-1" }
fi
