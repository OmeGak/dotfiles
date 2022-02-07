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

# Sensible navigation
[[ -n "${key[Home]}" ]]         && bindkey "${key[Home]}"         beginning-of-line
[[ -n "${key[End]}" ]]          && bindkey "${key[End]}"          end-of-line
[[ -n "${key[Up]}" ]]           && bindkey "${key[Up]}"           up-line-or-beginning-search
[[ -n "${key[Down]}" ]]         && bindkey "${key[Down]}"         down-line-or-beginning-search
[[ -n "${key[Left]}" ]]         && bindkey "${key[Left]}"         backward-char
[[ -n "${key[Right]}" ]]        && bindkey "${key[Right]}"        forward-char
[[ -n "${key[C-Up]}" ]]         && bindkey "${key[C-Up]}"         up-line-or-history
[[ -n "${key[C-Down]}" ]]       && bindkey "${key[C-Down]}"       down-line-or-history
[[ -n "${key[C-Left]}" ]]       && bindkey "${key[C-Left]}"       backward-word
[[ -n "${key[C-Right]}" ]]      && bindkey "${key[C-Right]}"      forward-word
[[ -n "${key[Alt-Left]}" ]]     && bindkey "${key[Alt-Left]}"     backward-word-end
[[ -n "${key[Alt-Right]}" ]]    && bindkey "${key[Alt-Right]}"    forward-word-end

# Natural deletions
[[ -n "${key[Delete]}" ]]       && bindkey "${key[Delete]}"       delete-char
[[ -n "${key[C-Backspace]}" ]]  && bindkey "${key[C-Backspace]}"  backward-delete-word

# Prevent sending ~ if tmux didn't handle PageUp/PageDown
[[ -n "${key[PageUp]}" ]]       && bindkey "${key[PageUp]}"       beep
[[ -n "${key[PageDown]}" ]]     && bindkey "${key[PageDown]}"     beep


# -- Special keybindings ------------------------------------------------------

bindkey '^I' expand-or-complete-with-dots
bindkey '^[s' show-buffers
bindkey '^[k' forget-history

# Always pad pipe with whitespace
bindkey '|' self-insert-padded

# Pipe through pager
bindkey -s '^P' "|less\n"

# Reset iTerm2 profile
bindkey -s '^[r' 'iterm-profile^M'
