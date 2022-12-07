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
try pinstall pip spotdl

spotdl_conf="spotdl.config.json"
spotdl_conf_source="$DOT/apps/${spotdl_conf}"
spotdl_conf_target="$HOME/.spotdl/${spotdl_conf}"

# Link spotdl configuration
if [[ ! $(checklink "${spotdl_conf_target}" "${spotdl_conf_source}") ]]; then
  pprint info-go "Installing spotdl configuration"
  mksymlink "${spotdl_conf_source}" "${spotdl_conf_target}"
fi

exit $TRY_CODE
