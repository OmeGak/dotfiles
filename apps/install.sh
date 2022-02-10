#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew duply
try pinstall brew exercism
try pinstall brew jupyter
try pinstall brew httpie
try pinstall brew pandoc
try pinstall brew pass
try pinstall brew speedtest-cli
try pinstall brew yt-dlp
try pinstall gem boom
try pinstall pip xkcdpass
try pinstall pip ytmdl

exit $TRY_CODE
