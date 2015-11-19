#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ "$(uname -s)" == "Linux" ]]; then
  args="--with-brewed-curl --with-brewed-openssl --without-tcl-tk"
fi

try pinstall brew git ${args}
try pinstall brew hub
exit $TRY_CODE
