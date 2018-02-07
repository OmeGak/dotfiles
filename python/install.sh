#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall pip2 pip
try pinstall pip3 pipenv
try pinstall pip2 ipython
try pinstall pip2 virtualenv
try pinstall pip2 virtualenvwrapper
try pinstall pip2 wdb.server
exit $TRY_CODE
