#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint error "Unsupported OS"
  exit 0
fi

# Install my keyboard layout
ln -snf "$ZSH/osx/US-ES-Keyboard/US-ES-International.bundle" "$HOME/Library/Keyboard Layouts/US-ES-International.bundle"
pprint ok "US-ES-Keyboard installed for user"

# Install NTFS support
brew install ntfs-3g > /tmp/brew-ntfs-3g.dot.log 2>&1
pprint ok "NTFS support added to Mac OS"
exit 0
