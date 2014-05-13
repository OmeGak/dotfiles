#!/bin/bash
set -e

if [[ "$(uname -s)" == "Darwin" ]]; then
  fonts_dir="$HOME/Library/Fonts"
elif [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
else
  echo "Unrecognized OS"
  exit
fi

echo "Installing Fonts into $fonts_dir."
cp $ZSH/system/fonts/* $fonts_dir

# Uncomment if fonts are not available
# echo "Refreshing fonts cache"
# fc-cache -f
