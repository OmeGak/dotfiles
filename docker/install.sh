#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew docker-completion
try pinstall brew lazydocker

exit $TRY_CODE
