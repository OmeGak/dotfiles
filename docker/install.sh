#!/usr/bin/env bash
source $DOT/functions/try

try pinstall brew docker
try pinstall brew boot2docker
exit $TRY_CODE
