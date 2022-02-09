#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try brew tap homebrew/cask-drivers > /dev/null 2>&1
try brew tap omegak/brewery git@github.com:OmeGak/brewery.git > /dev/null 2>&1

exit $TRY_CODE
