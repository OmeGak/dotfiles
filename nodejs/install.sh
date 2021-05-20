#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew nvm
try pinstall brew yarn
exit $TRY_CODE
