#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew cowsay
exit $TRY_CODE
