#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew pgcli
try pinstall brew postgresql
exit $TRY_CODE
