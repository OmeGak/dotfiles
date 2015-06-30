#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint info-warn "Step skipped: This is not a Mac"
  exit 0
fi

plist_name="com.googlecode.iterm2.plist"
plist_source="$DOT/iterm/${plist_name}"
plist_target="$HOME/Library/Preferences/${plist_name}"

# Link preferences
if [[ ! $(checklink "${plist_target}" "${plist_source}") ]]; then
  if [[ "$(rnapp iterm)" ]]; then
    pprint info-warn "iTerm is running"
    pprint info-warn "Do \`$ dot run\` from Terminal when iTerm is not running"
    exit 1
  fi
  pprint info-go "Installing preferences"
  killall cfprefsd  # Clean prefs cache
  createlink "${plist_source}" "${plist_target}"
fi

exit 0
