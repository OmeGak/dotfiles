#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew mosh

if [[ "$OS" == "Linux" ]]; then
  try pinstall apt openssh-server
fi

exit $TRY_CODE
