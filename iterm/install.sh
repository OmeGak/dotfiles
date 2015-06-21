#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint warning "Step skipped: This is not a Mac"
  exit 0
fi

if [[ ! "$(whichapp iterm 2> /dev/null)" ]]; then
  pprint warning "iTerm doesn't seem to be installed"
  exit 0
fi

plist_name="com.googlecode.iterm2.plist"
plist_source="$DOT/iterm/${plist_name}"
plist_target="$HOME/Library/Preferences/${plist_name}"

# Check if preferences were ever imported
if [[ ! -f ${plist_target}.backup ]]; then
  if [[ $TERM_PROGRAM = 'iTerm.app' ]]; then
    pprint warning "iTerm can't overwrite its own preferences"
    pprint warning "Run \`$ dot install\` from Terminal instead"
    exit 1
  fi
  pprint step "Backing up prefs and importing yours"
  killall cfprefsd  # Clean prefs cache
  mv "${plist_target}" "${plist_target}.backup"
  cp "${plist_source}" "${plist_target}"
fi

exit 0
