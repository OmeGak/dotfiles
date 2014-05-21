#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  sublime_dir="$HOME/Library/Application Support/Sublime Text 3/Packages"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sublime_dir="$HOME/.config/sublime-text-3/Packages"
else
  print error "Unrecognized OS"
  exit 0
fi

# Link ST settings
rm -rf "$sublime_dir/Backup_User"
mv "$sublime_dir/User" "$sublime_dir/Backup_User"
pprint ok "Backed up installed preferences"

ln -s "$ZSH/sublimetext/User" "$sublime_dir"
pprint ok "Your preferences are now linked"

pprint ok "SublimeText is ready to hack!"
exit 0
