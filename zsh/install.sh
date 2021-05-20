#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew direnv
try pinstall brew exa
try pinstall brew fzf
try pinstall brew starship
