#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew docker
try pinstall brew docker-machine
exit $TRY_CODE
