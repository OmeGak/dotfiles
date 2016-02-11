#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew perl
try pinstall brew aspell
try pinstall brew weechat --with-perl --with-aspell
exit $TRY_CODE
