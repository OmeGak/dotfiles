#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew perl
try pinstall brew weechat --with-perl
exit $TRY_CODE
