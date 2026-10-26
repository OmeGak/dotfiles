#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew bat
try pinstall brew cliclick
try pinstall brew cmatrix
try pinstall brew coreutils
try pinstall brew dust
try pinstall brew f2
try pinstall brew fd
try pinstall brew ffmpeg
try pinstall brew glances
try pinstall brew grc
try pinstall brew hyperfine
try pinstall brew make
try pinstall brew monolith
try pinstall brew openssl
try pinstall brew procs
try pinstall brew pulseaudio
try pinstall brew ripgrep
try pinstall brew tailcat
try pinstall brew tealdeer
try pinstall brew unar
try pinstall brew wget
try pinstall uv maildump

# fonts
try pinstall brew font-sauce-code-pro-nerd-font
try pinstall brew font-source-code-pro

# Make sure gnupg is not linked as it will collide with GPGTools
brew unlink gnupg > /dev/null 2>&1

exit $TRY_CODE
