#!/usr/bin/env bash
source $DOT/functions/try

try pinstall pip nodeenv
exit $TRY_CODE
