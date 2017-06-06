#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew ansible
exit $TRY_CODE
