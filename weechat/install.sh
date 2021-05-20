#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew perl
try pinstall brew aspell
try pinstall brew weechat

if [[ "$OS" == "Darwin" ]]; then
  try pinstall pip pync
fi

if [[ "$OS" == "Linux" ]]; then
  try pinstall brew dbus
  try pinstall pip dbus-python
  try pinstall pip notify2
fi

exit $TRY_CODE
