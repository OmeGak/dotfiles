if (( $+commands[docker] )); then
  compdef dcompose='docker compose'
fi

if (( $+commands[kubectl] )); then
  compdef k='kubectl'
fi
