# Widgets to be used with `zle`

backward-word-end() {
  [[ $RBUFFER[1] == ' ' ]] && zle backward-char
  zle vi-backward-blank-word-end
  [[ $#LBUFFER != 0 ]] && zle forward-char
}
zle -N backward-word-end
unset backward-word-end

forward-word-end() {
  zle vi-forward-blank-word-end
  zle forward-char
}
zle -N forward-word-end
unset forward-word-end
