#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew perl
try pinstall brew aspell
try pinstall brew weechat

if [[ "$OS" == "Darwin" ]]; then
  try pinstall pip3 pync
fi

if [[ "$OS" == "Linux" ]]; then
  try pinstall brew dbus
  try pinstall pip3 dbus-python
  try pinstall pip3 notify2
fi

exit $TRY_CODE
