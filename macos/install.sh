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
    # XXX: Layouts need to be copied rather than symlinked, otherwise they may not work with some applications
    cp "${source_bundle}" "${target_bundle_local}"
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

install_spicetify() {
  try pinstall brew spicetify-cli

  # Patching needs Spotify installed and launched once; a later run catches up.
  if [[ ! -d /Applications/Spotify.app ]]; then
    pprint info-warn "Skipping Spicetify apply: Spotify is not installed"
    return
  fi
  pprint info-go "Applying Spicetify"
  if [[ -f /Applications/Spotify.app/Contents/Resources/Apps/xpui.spa ]]; then
    # Unpatched Spotify: the tracked [Backup] section describes another
    # install, and Spicetify won't back up while it claims a backup exists.
    sed -i '' -E 's/^(version|with)( *)=.*/\1\2= /' "$HOME/.config/spicetify/config-xpui.ini"
    spicetify backup apply
  else
    spicetify apply
  fi
}

# apps.txt holds the App Store apps a fresh Mac gets, one `<id>  <name>` per
# line: a chosen few, not everything installed. `mas list` shows the ids.
# mas skips apps already installed, and needs root to install.
install_app_store_apps() {
  pprint info-go "Installing App Store apps"
  awk '{print $1}' "$DOT/macos/apps.txt" | xargs sudo mas install
}

install_keyboard_layout
install_rectangle_prefs
install_app_store_apps
install_spicetify

exit 0
