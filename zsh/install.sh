#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew zsh
exit $TRY_CODE
