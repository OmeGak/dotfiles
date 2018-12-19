#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew haskell-stack
exit $TRY_CODE
