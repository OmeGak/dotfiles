#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew claude
try pinstall brew codex
try pinstall brew copilot-cli
try pinstall brew rtk

try pinstall npm ccstatusline

exit $TRY_CODE
