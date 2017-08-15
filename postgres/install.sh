#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew pgcli
exit $TRY_CODE
