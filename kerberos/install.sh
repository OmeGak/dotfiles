#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ $(uname -s) == 'Linux' ]]; then
  try pinstall apt openafs-client
  try pinstall apt openafs-module-dkms
  try pinstall apt openafs-krb5
  try pinstall apt krb5-user
  try pinstall apt krb5-config
  try pinstall apt kstart
fi

exit $TRY_CODE
