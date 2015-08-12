#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall pip pip
try pinstall pip ipython
try pinstall pip tmuxp
try pinstall pip wdb.server
exit $TRY_CODE
