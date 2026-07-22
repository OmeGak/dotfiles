if (( $+commands[docker] )); then
  compdef dcompose='docker compose'
fi

if (( $+commands[kubectl] )); then
  compdef k='kubectl'
fi

if (( $+commands[tofu] )); then
  complete -o nospace -C /usr/local/bin/tofu tofu
fi
