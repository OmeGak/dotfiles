#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew duply
exit $TRY_CODE
