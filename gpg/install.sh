#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall cask gpgtools
exit $TRY_CODE
