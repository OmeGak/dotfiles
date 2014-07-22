#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint error "Unsupported OS"
  exit 0
fi

plist_name="com.googlecode.iterm2.plist"
plist_source="$ZSH/iterm/$plist_name"
plist_target="$HOME/Library/Preferences/$plist_name"

mv "$plist_target" "$plist_target.backup"
pprint ok "Backed up installed preferences"

pprint warning "Make sure iTerm2 is not running for this step to work"
cp "$plist_source" "$plist_target"
pprint ok "Your preferences are now imported"

exit 0
