#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall pip2 nodeenv
try pinstall brew yarn
exit $TRY_CODE
