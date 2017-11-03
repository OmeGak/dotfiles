#!/usr/bin/env bash

if [[ "$OS" != "Darwin" ]]; then
  pprint info-warn "Step skipped: iTerm is only available for macOS"
  exit 0
fi

failoniterm() {
  if [[ "$(rnapp iterm)" ]]; then
    pprint info-warn "iTerm is running"
    pprint info-warn "Invoke \`dot install\` from Terminal when iTerm is not running"
    exit 1
  fi
}

plist_name="com.googlecode.iterm2.plist"
plist_source="$DOT/iterm/${plist_name}"
plist_target="$HOME/Library/Preferences/${plist_name}"

# Link preferences
if [[ ! $(checklink "${plist_target}" "${plist_source}") ]]; then
  failoniterm
  pprint info-go "Installing preferences"
  killall cfprefsd  # Clean prefs cache
  mksymlink "${plist_source}" "${plist_target}"
fi

profiles_source="$DOT/iterm/profiles"
profiles_target="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

# Link profiles
if [[ ! $(checklink "${profiles_target}" "${profiles_source}") ]]; then
  failoniterm
  pprint info-go "Installing profiles"
  mksymlink "${profiles_source}" "${profiles_target}"
fi

exit $TRY_CODE
