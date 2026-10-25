#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew duply
try pinstall brew exercism
try pinstall brew jupyter
try pinstall brew httpie
try pinstall brew pandoc
try pinstall brew pass
try pinstall brew restic
try pinstall brew speedtest-cli
try pinstall brew yt-dlp
try pinstall gem boom
try pinstall uv xkcdpass
try pinstall uv spotdl

exit $TRY_CODE
