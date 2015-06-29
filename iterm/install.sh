#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint info-warn "Step skipped: This is not a Mac"
  exit 0
fi

if [[ ! "$(whichapp iterm 2> /dev/null)" ]]; then
  pprint info-warn "iTerm doesn't seem to be installed"
  exit 0
fi

plist_name="com.googlecode.iterm2.plist"
plist_source="$DOT/iterm/${plist_name}"
plist_target="$HOME/Library/Preferences/${plist_name}"

# Check if preferences were already imported
if [[ $(readlink "${plist_target}") != "${plist_source}" ]]; then
  if [[ "$(rnapp iterm)" ]]; then
    pprint info-warn "iTerm is running"
    pprint info-warn "Do \`$ dot run\` from Terminal when iTerm is not running"
    exit 1
  fi
  pprint info-go "Importing preferences"
  # Clean prefs cache
  killall cfprefsd
  # Backup and link
  [[ -f "${plist_target}" ]] && mv "${plist_target}" "${plist_target}.bak"
  ln -snf "${plist_source}" "${plist_target}"
fi

exit 0
