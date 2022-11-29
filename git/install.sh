#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew git
try pinstall brew git-interactive-rebase-tool
try pinstall brew git-lfs
try pinstall brew hub
try pinstall brew tig

exit $TRY_CODE
