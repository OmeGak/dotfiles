#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint error "Unsupported OS"
  exit 0
fi

if [[ $TERM_PROGRAM = 'iTerm.app' ]]; then
  pprint warning "Step skipped: you can't run this script from iTerm"
  exit 0
fi

# Clean prefs cache
killall cfprefsd

plist_name="com.googlecode.iterm2.plist"
plist_source="$ZSH/iterm/$plist_name"
plist_target="$HOME/Library/Preferences/$plist_name"

mv "$plist_target" "$plist_target.backup"
pprint ok "Backed up old preferences"

cp "$plist_source" "$plist_target"
pprint ok "Your preferences has been imported"

exit 0
