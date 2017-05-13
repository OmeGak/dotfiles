#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ $OS == 'Linux' ]]; then
  pprint info-warn "Step skipped: Better not install in Linux"
  exit 0
fi

try pinstall cask docker
exit $TRY_CODE
