#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  sublime_bin="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
  sublime_dir="$HOME/Library/Application Support/Sublime Text 3/Packages"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sublime_bin="/usr/bin/sublime-text-3"
  sublime_dir="$HOME/.config/sublime-text-3/Packages"
else
  print error "Unrecognized OS"
  exit 0
fi

# Link ST binary
if test ! $(which subl); then
  ln -s $sublime_bin $ZSH/bin/subl
  pprint ok "Sublime Text binary linked"
fi

# Link ST settings
rm -rf "$sublime_dir/Backup_User"
mv "$sublime_dir/User" "$sublime_dir/Backup_User"
pprint ok "Backed up installed preferences"

ln -s "$ZSH/sublime2/User" "$sublime_dir"
pprint ok "Your preferences are now linked"

pprint ok "SublimeText is ready to hack!"
exit 0
