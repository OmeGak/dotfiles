#!/bin/sh
set -e

if [[ "$(uname -s)" == "Darwin" ]]; then
  fonts_dir="$HOME/Library/Fonts"
elif [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
else
  echo "Unrecognized OS"
  exit
fi

echo "Installing Fonts."
cp -R $fonts_dir $fonts_dir.backup
cp $ZSH/system/fonts/* $fonts_dir

# TODO check if truly necessary
fc-cache -f -v
