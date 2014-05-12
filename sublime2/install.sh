#!/bin/bash
# Setup a machine for Sublime Text 2

# setting path
if [[ "$(uname -s)" == "Darwin" ]]; then
  sublime_dir="$HOME/Library/Application Support/Sublime Text 2/Packages"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sublime_dir="$HOME/.config/sublime-text-2/Packages"
else
  echo "Unrecognized OS"
  exit
fi

# backup and symlink
mv "$sublime_dir/User" "$sublime_dir/User.backup"
ln -s "$ZSH/sublime2/User" "$sublime_dir"
