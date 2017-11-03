#!/usr/bin/env bash
source $DOT/.dot/functions/try

try brew tap caskroom/drivers > /dev/null 2>&1

exit $TRY_CODE
