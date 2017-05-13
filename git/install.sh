#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ "$OS" == "Linux" ]]; then
  args="--with-brewed-curl --with-brewed-openssl --without-tcl-tk"
fi

try pinstall brew git ${args}
try pinstall brew hub
try pinstall npm git-standup

if [[ "$OS" == "Darwin" ]]; then
  try pinstall cask p4merge
fi

exit $TRY_CODE
