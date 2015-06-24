#!/usr/bin/env bash
source $DOT/functions/try

try pinstall brew git
try pinstall brew hub
exit $TRY_CODE
