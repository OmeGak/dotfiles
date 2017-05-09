#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ $OS == 'Darwin' ]]; then
  try pinstall cask docker
else
  try pinstall brew docker
  try pinstall brew docker-compose
fi

exit $TRY_CODE
