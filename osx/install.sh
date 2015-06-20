#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint warning "Step skipped: This is not a Mac"
  exit 0
fi

install_keyboard_layout() {
  local source_bundle="$DOT/osx/US-ES-Keyboard/US-ES-International.bundle"
  local target_bundle="$HOME/Library/Keyboard Layouts/US-ES-International.bundle"

  # Check if keyboard layout is not installed
  if [[ ! -d ${target_bundle} ]]; then
    pprint step "Installing US-ES-Keybouard layout"
    cp -r "${source_bundle}" "${target_bundle}"
    # Apparently, symlinked keyboard layouts don't work on most of native Apple apps in Yosemite, at least
    # ln -snf "${source_bundle}" "${target_bundle}"
  fi
}

install_ntfs() {
  pinstall brew ntfs-3g
  [[ $? != 0 ]] && exit 1

  # Check if mount_ntfs is symlinked
  if [[ ! -L "/sbin/mount_ntfs" ]]; then
    pprint warning "NTFS-3g is ready but you still need to replace the automounter manually"
    pprint warning "This is a DANGEROUS operation, so proceed with care:"
    pprint warning "  $ brew info ntfs-3g"
    pprint warning "  $ sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig"
    pprint warning "  $ sudo ln -s <path_to_ntfs_version>/sbin/mount_ntfs /sbin/mount_ntfs"
  else
    pprint ok "NTFS is enabled"
  fi
}

install_keyboard_layout
install_ntfs

exit 0
