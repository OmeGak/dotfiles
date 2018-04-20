#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew reattach-to-user-namespace
try pinstall brew tmux
try pinstall pip3 tmuxp
exit $TRY_CODE
