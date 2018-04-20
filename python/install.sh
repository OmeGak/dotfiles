#!/usr/bin/env bash
source $DOT/.dot/functions/try

# Python 2 tools
try pinstall pip2 pip

# Python 3 tools
try pinstall pip3 pip
try pinstall pip3 ipython
try pinstall pip3 pipenv
try pinstall pip3 tox
try pinstall pip3 wdb.server

exit $TRY_CODE
