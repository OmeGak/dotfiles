#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall pip powerline-status
exit $TRY_CODE
