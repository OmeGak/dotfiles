#!/usr/bin/env bash
set -e

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Unsupported OS"
  exit
fi

echo "Installing iTerm preferences."

plist_name="com.googlecode.iterm2.plist"
plist_source="$ZSH/iterm/$plist_name"
plist_target="$HOME/Library/Preferences/$plist_name"

mv "$plist_target" "$plist_target.backup"
ln -s "$plist_source" "$plist_target"
echo "iTerm preferences linked."
