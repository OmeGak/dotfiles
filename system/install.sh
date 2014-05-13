#!/bin/bash
set -e

if [[ "$(uname -s)" == "Darwin" ]]; then
  fonts_dir="$HOME/Library/Fonts"
elif [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
else
  pprint error "Unrecognized OS"
  exit 1
fi

cp $ZSH/system/fonts/* $fonts_dir
pprint ok "Installed fonts into $fonts_dir"

# Uncomment if fonts are not available
# echo "Refreshing fonts cache"
# fc-cache -f

exit 0
