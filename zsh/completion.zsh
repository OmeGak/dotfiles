# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# eza replacements
if (( $+commands[eza] )); then
  compdef ls='eza'
  compdef ll='eza'
  compdef la='eza'
  compdef tree='eza'
fi
