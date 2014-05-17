#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  fonts_dir="$HOME/Library/Fonts"
elif [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
else
  pprint error "Unrecognized OS"
  exit 0
fi

cp $ZSH/system/fonts/* $fonts_dir
pprint ok "Installed fonts into $fonts_dir"

# Uncomment if fonts are not available
# echo "Refreshing fonts cache"
# fc-cache -f

if [[ "$(uname -s)" == "Darwin" ]]; then
  brew install ack
elif [[ "$(uname -s)" == "Linux" ]]; then
  # TODO
fi

pprint ok "System tools are ready"
exit 0
