#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ "$(uname -s)" == "Linux" ]]; then
  try pinstall apt openssh-server
fi

try brew tap thefox/brewery > /dev/null 2>&1
try pinstall brew phook

exit $TRY_CODE
