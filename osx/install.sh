#!/usr/bin/env bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint error "Unsupported OS"
  exit 0
fi

ln -snf "$ZSH/osx/US-ES-Keyboard/US-ES-International.bundle" "$HOME/Library/Keyboard Layouts/US-ES-International.bundle"
pprint ok "US-ES-Keyboard installed for user"
exit 0
