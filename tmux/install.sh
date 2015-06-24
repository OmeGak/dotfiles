#!/usr/bin/env bash
source $DOT/functions/try

try pinstall pip tmuxp
exit $TRY_CODE
