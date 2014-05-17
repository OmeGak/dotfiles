#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  sublime_dir="$HOME/Library/Application Support/Sublime Text 2/Packages"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sublime_dir="$HOME/.config/sublime-text-2/Packages"
else
  print error "Unrecognized OS"
  exit 0
fi

rm -rf "$sublime_dir/Backup_User"
mv "$sublime_dir/User" "$sublime_dir/Backup_User"
pprint ok "Backed up installed preferences"

ln -s "$ZSH/sublime2/User" "$sublime_dir"
pprint ok "Your ST2 preferences are now linked"

exit 0
