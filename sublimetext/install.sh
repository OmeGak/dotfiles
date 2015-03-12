#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  sublime_dir="$HOME/Library/Application Support/Sublime Text 3"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sublime_dir="$HOME/.config/sublime-text-3"
else
  print error "Unrecognized OS"
  exit 0
fi

sublime_pkgcontrol="$sublime_dir/Installed Packages/Package Control.sublime-package"
sublime_pkgs_dir="$sublime_dir/Packages"

# Install Package Control
if [[ ! -e "$sublime_pkgcontrol" ]]; then
  server_url="https://packagecontrol.io/Package%20Control.sublime-package"
  curl -fsSL -o "$sublime_pkgcontrol" "$server_url"
  pprint ok "Package Control installed"
fi

# Back up ST settings
if [[ ! -d "$sublime_pkgs_dir/User.bak" ]]; then
  mv "$sublime_pkgs_dir/User" "$sublime_pkgs_dir/User.bak"
  pprint ok "Backed up installed preferences"
fi

# Link ST settings
rm -rf "$sublime_pkgs_dir/User"
ln -snf "$ZSH/sublimetext/User" "$sublime_pkgs_dir/User"
pprint ok "Your preferences are now linked"

pprint ok "SublimeText is ready to hack!"
exit 0
