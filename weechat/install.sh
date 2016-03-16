#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew perl
try pinstall brew aspell
try pinstall brew weechat --with-aspell --with-perl --with-python

if [[ "$(uname -s)" == "Darwin" ]]; then
  try pinstall pip pync
fi

if [[ "$(uname -s)" == "Linux" ]]; then
  # Necessary since dbus-1 and dbus-glib-1 are outside of brew
  export PKG_CONFIG_PATH=$(/usr/bin/pkg-config --variable pc_path pkg-config)
  try pinstall pip dbus-python
  try pinstall pip notify2
fi

exit $TRY_CODE
