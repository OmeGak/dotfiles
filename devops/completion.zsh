if (( $+commands[kubectl] )); then
  compdef k='kubectl'
fi

if (( $+commands[tofu] )); then
  complete -o nospace -C "$BREWDIR/bin/tofu" tofu
fi
