#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

if [[ "$OS" != "Darwin" ]]; then
  pprint info-warn "Step skipped: This is not a Mac"
  exit 0
fi

try pinstall brew mas
# FUSE-T gives sshfs a FUSE layer without a kernel extension:
# Homebrew's own sshfs needs libfuse, which only Linux has.
try pinstall brew fuse-t
# The fuse-t-sshfs cask's sshfs drops newer FUSE-T options (noappledouble):
# the tap's formula builds it against the installed FUSE-T instead.
try pinstall brew omegak/brewery/sshfs-fuse-t
try pinstall brew spicetify-cli

# Layouts are copied, not linked: some applications don't follow a link
layout="$HOME/Library/Keyboard Layouts/US-ES-International.bundle"
if [[ ! -d ${layout} ]]; then
  pprint info-go "Installing the US-ES-Keyboard layout"
  cp -R "$DOT/macos/US-ES-Keyboard/US-ES-International.bundle" "${layout}"
fi

# apps.txt holds the App Store apps a fresh Mac gets, one `<id>  <name>` per
# line: a chosen few, not everything installed. `mas list` shows the ids.
# Only the missing ones are installed, and mas needs root for that.
missing=$(awk '{print $1}' "$DOT/macos/apps.txt" | grep -vxFf <(mas list | awk '{print $1}'))
if [[ ${missing} ]]; then
  # shellcheck disable=SC2086
  try prun "Installing App Store apps" sudo mas install ${missing}
fi

exit $TRY_CODE
