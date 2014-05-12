#!/bin/sh
cd "$(dirname $0)"

if [[ "$(uname -s)" == "Darwin" ]]; then
  fonts_dir=~/Library/Fonts
elif [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir=~/.fonts
else
  echo "Unrecognized OS"
  exit
fi

echo "Installing Fonts."
cp -R $fonts_dir $fonts_dir.backup
cp fonts/* $fonts_dir

# TODO check if truly necessary
fc-cache -f -v
