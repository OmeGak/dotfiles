# Compatibility keybindings
# Source: http://stackoverflow.com/a/29403520/1901977

# Bind hex 0x18 0x7f (cmd-delete) to deleting left of the cursor
bindkey "^X\\x7f" backward-kill-line

# Bind hex 0x18 0x1f (shift-cmd-Z) to redo
bindkey "^X^_" redo
