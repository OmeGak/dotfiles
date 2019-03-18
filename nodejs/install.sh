#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall pip3 nodeenv
try pinstall brew yarn
exit $TRY_CODE
