#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint error "Unsupported OS"
  exit 0
fi

# Install my keyboard layout
# Apparently, symlinked keyboard layouts don't work on most of native Apple apps in Yosemite, at least
# ln -snf "$ZSH/osx/US-ES-Keyboard/US-ES-International.bundle" "$HOME/Library/Keyboard Layouts/US-ES-International.bundle"
cp -r "$ZSH/osx/US-ES-Keyboard/US-ES-International.bundle" "$HOME/Library/Keyboard Layouts/US-ES-International.bundle"
pprint ok "US-ES-Keyboard installed for user"

# Install NTFS support
brew install ntfs-3g > /tmp/brew-ntfs-3g.dot.log 2>&1
if [[ ! -L "/sbin/mount_ntfs" ]]; then
  pprint warning "NTFS-3g is ready but you still need to replace the automounter manually"
  pprint warning "This is a DANGEROUS operation, so proceed with care:"
  pprint warning "  $ brew info ntfs-3g"
  pprint warning "  $ sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig"
  pprint warning "  $ sudo ln -s <path_to_ntfs_version>/sbin/mount_ntfs /sbin/mount_ntfs"
  exit 0
fi

pprint ok "Write to NTFS is enabled"
exit 0
