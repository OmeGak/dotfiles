#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

if [[ "$OS" != "Darwin" ]]; then
  pprint info-warn "Step skipped: This is not a Mac"
  exit 0
fi

try pinstall brew mas

install_keyboard_layout() {
  local source_bundle="$DOT/macos/US-ES-Keyboard/US-ES-International.bundle"
  local target_bundle_local="$HOME/Library/Keyboard Layouts/US-ES-International.bundle"

  if [[ ! -d ${target_bundle_local} ]]; then
    pprint info-go "Installing US-ES-Keyboard layout locally"
    mksymlink "${source_bundle}" "${target_bundle_local}"
  fi
}

install_rectangle_prefs() {
  plist_name="com.knollsoft.Rectangle.plist"
  plist_source="$DOT/macos/${plist_name}"
  plist_target="$HOME/Library/Preferences/${plist_name}"

  if [[ ! $(checklink "${plist_target}" "${plist_source}") ]]; then
    pprint info-go "Installing Rectangle preferences"
    mksymlink "${plist_source}" "${plist_target}"
  fi
}

install_keyboard_layout
install_rectangle_prefs

exit 0
