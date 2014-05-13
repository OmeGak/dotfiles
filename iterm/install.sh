#!/usr/bin/env bash
set -e

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint error "Unsupported OS"
  exit 1
fi

plist_name="com.googlecode.iterm2.plist"
plist_source="$ZSH/iterm/$plist_name"
plist_target="$HOME/Library/Preferences/$plist_name"

mv "$plist_target" "$plist_target.backup"
pprint ok "Backed up installed preferences"

ln -s "$plist_source" "$plist_target"
pprint ok "Linked your preferences"

exit 0
