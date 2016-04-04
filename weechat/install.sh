#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew perl
try pinstall brew aspell
try pinstall brew weechat --with-aspell --with-perl --with-python

if [[ "$(uname -s)" == "Darwin" ]]; then
  try pinstall pip pync
fi

if [[ "$(uname -s)" == "Linux" ]]; then
  try pinstall brew dbus
  try pinstall pip dbus-python
  try pinstall pip notify2
fi

exit $TRY_CODE
