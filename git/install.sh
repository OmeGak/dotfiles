#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ "$OS" == "Linux" ]]; then
  args="--with-brewed-curl --with-brewed-openssl --without-tcl-tk"
fi

try brew tap git-duet/tap > /dev/null 2>&1

try pinstall brew git ${args}
try pinstall brew hub
try pinstall brew git-duet
try pinstall npm git-standup

# Required for git-ngrok
try pinstall brew jq

exit $TRY_CODE
