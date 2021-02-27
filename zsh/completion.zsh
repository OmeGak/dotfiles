# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# exa replacements
if (( $+commands[exa] )); then
  compdef ls='exa'
  compdef ll='exa'
  compdef la='exa'
  compdef tree='exa'
fi
