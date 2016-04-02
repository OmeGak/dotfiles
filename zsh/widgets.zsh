# Widgets to be used with `zle`


# -- Debugging ----------------------------------------------------------------

# Source: http://stackoverflow.com/a/2649659
show-buffers() {
  local nl=$'\n' kr
  typeset -T kr KR $'\n'
  KR=($killring)
  typeset +g -a buffers
  buffers+="      Pre: ${PREBUFFER:-$nl}"
  buffers+="  Buffer: $BUFFER$nl"
  buffers+="     Cut: $CUTBUFFER$nl"
  buffers+="       L: $LBUFFER$nl"
  buffers+="       R: $RBUFFER$nl"
  buffers+="AutoSugg: $POSTDISPLAY$nl"
  buffers+="Killring:$nl$nl$kr"
  zle -M "$buffers"
}
zle -N show-buffers
unset show-buffers


# -- Movement -----------------------------------------------------------------

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


# -- Plugins ------------------------------------------------------------------

# For zsh-autosuggest
next-suggested-word() {
  [[ $RBUFFER[1] == ' ' ]] && zle .forward-word
  zle .forward-word
}
zle -N next-suggested-word
unset next-suggested-word
