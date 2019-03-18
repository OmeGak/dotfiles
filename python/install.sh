#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew pipenv
try pinstall brew tox
try pinstall pip3 ipython
try pinstall pip3 wdb.server

exit $TRY_CODE
