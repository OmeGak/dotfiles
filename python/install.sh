#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall pip pip
try pinstall pip3 pipenv
try pinstall pip ipython
try pinstall pip virtualenv
try pinstall pip virtualenvwrapper
try pinstall pip wdb.server
exit $TRY_CODE
