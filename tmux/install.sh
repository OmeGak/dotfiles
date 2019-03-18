#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew reattach-to-user-namespace
try pinstall brew tmux
try pinstall pip3 tmuxp
exit $TRY_CODE
