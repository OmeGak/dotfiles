#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew mosh
try pinstall brew sshrc

if [[ "$OS" == "Darwin" ]]; then
  try brew tap thefox/brewery > /dev/null 2>&1
  try pinstall brew phook
else
  try pinstall apt openssh-server
fi

exit $TRY_CODE
