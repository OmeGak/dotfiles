#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

if [[ "$OS" == "Linux" ]]; then
  args="--with-brewed-curl --with-brewed-openssl --without-tcl-tk"
fi

try pinstall brew git "${args}"
try pinstall brew git-interactive-rebase-tool
try pinstall brew git-lfs
try pinstall brew hub
try pinstall brew tig

# Required for git-ngrok
try pinstall brew jq

exit $TRY_CODE
