#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew perl
try pinstall brew aspell
try pinstall brew weechat --with-aspell --with-perl --with-python

if [[ "$OS" == "Darwin" ]]; then
  try pinstall pip2 pync
fi

if [[ "$OS" == "Linux" ]]; then
  try pinstall brew dbus
  try pinstall pip2 dbus-python
  try pinstall pip2 notify2
fi

exit $TRY_CODE
