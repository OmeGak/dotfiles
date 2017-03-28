# Widgets to be used with `zle`


# -- Debugging ----------------------------------------------------------------

# Source: http://stackoverflow.com/a/2649659
zle-show-buffers() {
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
zle -N show-buffers zle-show-buffers


# -- Movement -----------------------------------------------------------------

zle-backward-word-end() {
  [[ $RBUFFER[1] == ' ' ]] && zle backward-char
  zle vi-backward-blank-word-end
  [[ $#LBUFFER != 0 ]] && zle forward-char
}
zle -N backward-word-end zle-backward-word-end

zle-forward-word-end() {
  zle vi-forward-blank-word-end
  zle forward-char
}
zle -N forward-word-end zle-forward-word-end


# -- Completion ---------------------------------------------------------------

# Show dots while waiting to complete. Useful for systems with slow net access,
# like those places where they use giant, slow NFS solutions. (Hint.)
zle-expand-or-complete-with-dots() {
  echo -n "\e[31m...\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots zle-expand-or-complete-with-dots


# -- History control ----------------------------------------------------------

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

# Remove input/suggestion from history
zle-forget-history() {
  local cmd=$BUFFER$POSTDISPLAY
  # Trim trailing whitespace
  cmd=${cmd//[[:space:]]%/}
  # Clean buffer
  region_highlight=("0 ${#cmd} bold,standout")
  BUFFER=${cmd}
  zle send-break
  # Forget history
  histrm "${cmd}"
  histrl
}
zle -N forget-history zle-forget-history


# -- Misc ---------------------------------------------------------------------

# Automatically escape URLs as you type
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Enter white spaces around the inserted key
# Based on: http://www.zsh.org/mla/users/2006/msg00690.html
zle-self-insert-padded() {
  setopt localoptions noksharrays
  zle self-insert
  [[ $LBUFFER[-2] != " " ]] && LBUFFER[-1]=" $LBUFFER[-1]"
  LBUFFER[-1]="$LBUFFER[-1] "
}
zle -N self-insert-padded zle-self-insert-padded


# -- Plugins ------------------------------------------------------------------

zle-next-suggested-word() {
  [[ $RBUFFER[1] == ' ' ]] && zle .forward-word
  zle .forward-word
}
zle -N next-suggested-word zle-next-suggested-word
