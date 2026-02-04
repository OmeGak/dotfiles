# Load VSCode shell integration if running inside VSCode terminal
if (( $+commands[code] )) && [[ "$TERM_PROGRAM" == "vscode" ]]; then
  source "$(code --locate-shell-integration-path zsh)"
fi
