#!/usr/bin/env bash

# Layouts are copied, not linked: some applications don't follow a link
layout="$HOME/Library/Keyboard Layouts/US-ES-International.bundle"
if [[ ! -d ${layout} ]]; then
  pprint info-go "Installing the US-ES-Keyboard layout"
  cp -R "$DOT/macos/US-ES-Keyboard/US-ES-International.bundle" "${layout}"
fi
