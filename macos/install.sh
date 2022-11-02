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

install_ntfs() {
  try brew tap homebrew/fuse > /dev/null 2>&1
  try pinstall brew ntfs-3g
  [[ $TRY_CODE != 0 ]] && exit 1

  # Check if mount_ntfs is symlinked
  if [[ "$(readlink /sbin/mount_ntfs)" != "$(brew --prefix)/sbin/mount_ntfs" ]]; then
    pprint info-warn "NTFS-3g is ready but you still need to do some things manually."
    pprint info-warn "Disable SIP filesystem lockdown from system recovery:"
    pprint info-warn "  $ csrutil enable --without fs"
    pprint info-warn "Replace the automounter. This is DANGEROUS. Proceed with care:"
    pprint info-warn "  $ sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig"
    pprint info-warn "  $ sudo ln -s `brew --prefix`/sbin/mount_ntfs /sbin/mount_ntfs"
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
install_ntfs
install_rectangle_prefs

exit 0
