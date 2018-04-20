compdef pipg='pip'

if (( $+commands[pip2] )); then
  compdef pip2='pip'
  compdef pipg2='pip'
fi

if (( $+commands[pip3] )); then
  compdef pip3='pip'
  compdef pipg3='pip'
fi
