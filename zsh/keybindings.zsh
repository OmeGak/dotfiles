# Set cross-terminal keybindings
# Idea borrowed from: https://github.com/gregf/dotfiles/blob/master/zsh/zkbd.zsh


# -- Load keys from system zkbd mapping ---------------------------------------

autoload -Uz zkbd
if [[ -f ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
    source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
else
    echo "WARNING: zkbd key mapping not found for your current terminal."
    echo "Execute \`zkbd\` to map keys."
fi


# -- Keybindings --------------------------------------------------------------

[[ -n "${key[Home]}" ]]      && bindkey "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}" ]]       && bindkey "${key[End]}"       end-of-line
[[ -n "${key[Delete]}" ]]    && bindkey "${key[Delete]}"    delete-char
[[ -n "${key[Up]}" ]]        && bindkey "${key[Up]}"        up-line-or-search
[[ -n "${key[Down]}" ]]      && bindkey "${key[Down]}"      down-line-or-search
[[ -n "${key[Left]}" ]]      && bindkey "${key[Left]}"      backward-char
[[ -n "${key[Right]}" ]]     && bindkey "${key[Right]}"     forward-char
[[ -n "${key[C-Up]}" ]]      && bindkey "${key[C-Up]}"      history-beginning-search-backward
[[ -n "${key[C-Down]}" ]]    && bindkey "${key[C-Down]}"    history-beginning-search-forward
[[ -n "${key[C-Left]}" ]]    && bindkey "${key[C-Left]}"    backward-word
[[ -n "${key[C-Right]}" ]]   && bindkey "${key[C-Right]}"   forward-word
[[ -n "${key[Alt-Left]}" ]]  && bindkey "${key[Alt-Left]}"  backward-word-end
[[ -n "${key[Alt-Right]}" ]] && bindkey "${key[Alt-Right]}" forward-word-end


# -- Special keybindings ------------------------------------------------------

# Pipe through pager
bindkey -s '^P' "|less\n"


# -- Magic keybindings --------------------------------------------------------

# Show dots while waiting to complete. Useful for systems with slow net access,
# like those places where they use giant, slow NFS solutions. (Hint.)
expand-or-complete-with-dots() {
  echo -n "\e[31m...\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# Ensure whitespaces around pipe.
# Based on: http://www.zsh.org/mla/users/2006/msg00690.html
self-insert-padded() {
  setopt localoptions noksharrays
  zle self-insert
  [[ $LBUFFER[-2] != " " ]] && LBUFFER[-1]=" $LBUFFER[-1]"
  LBUFFER[-1]="$LBUFFER[-1] "
}
zle -N self-insert-padded
bindkey "|" self-insert-padded
