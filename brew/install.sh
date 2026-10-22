#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try brew tap homebrew/cask-drivers > /dev/null 2>&1
try brew tap omegak/brewery git@github.com:OmeGak/brewery.git > /dev/null 2>&1
try brew tap macos-fuse-t/cask > /dev/null 2>&1

# Homebrew loads a third-party tap's formulae and casks only once it's trusted
try brew trust --tap omegak/brewery > /dev/null 2>&1
try brew trust --tap macos-fuse-t/cask > /dev/null 2>&1

exit $TRY_CODE
