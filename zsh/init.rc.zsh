# Enable bash completion for zsh
autoload -U +X bashcompinit && bashcompinit

# Enable starship prompt
eval "$(starship init zsh)"

# Enable direnv
eval "$(direnv hook zsh)"
