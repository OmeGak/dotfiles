#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall pip nodeenv
try pinstall brew yarn
exit $TRY_CODE
