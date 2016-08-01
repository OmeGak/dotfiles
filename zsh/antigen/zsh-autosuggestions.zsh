# Suggest by most recently executed cmd
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

# Style
[[ $(uname -s) == 'Darwin' ]] && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=236
[[ $(uname -s) == 'Linux' ]] && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=240

# Bind to widgets
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line vi-end-of-line)
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(delete-char)
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(forget-history show-buffers)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
  forward-char
  vi-forward-char
  forward-word
  forward-word-end
  next-suggested-word
)

# Accept suggestion with C-Space
[[ -n "${key[C-Space]}" ]] && bindkey "${key[C-Space]}" next-suggested-word

# Fix for IGNORE_EOF causing completion menu on EOF
bindkey '^D' beep
