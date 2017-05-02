#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ $OS == 'Linux' ]]; then
  try pinstall apt krb5-user
  try pinstall apt kstart
else
  try pinstall brew kstart
fi

exit $TRY_CODE
