#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew rbenv
try pinstall brew ruby-build
exit $TRY_CODE
