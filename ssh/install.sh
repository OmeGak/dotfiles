#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ "$(uname -s)" == "Linux" ]]; then
  try pinstall apt openssh-server
fi

exit $TRY_CODE
