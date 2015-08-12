#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall pip nodeenv
exit $TRY_CODE
