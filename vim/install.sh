#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew vim
exit $TRY_CODE
