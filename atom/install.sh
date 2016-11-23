#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall npm eslint
try pinstall npm eslint-plugin-promise
try pinstall npm eslint-config-standard
try pinstall npm eslint-plugin-standard
exit $TRY_CODE
