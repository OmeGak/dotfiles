#!/bin/bash
source $DOT/functions/try

try pinstall pip virtualenv
try pinstall pip virtualenvwrapper
exit $TRY_CODE
