#!/bin/bash
source $DOT/functions/try

try pinstall pip pip
try pinstall pip ipython
try pinstall pip tmuxp
try pinstall pip wdb.server
exit $TRY_CODE
