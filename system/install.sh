#!/bin/bash
source $DOT/functions/try

fonts_dir="$HOME/Library/Fonts"
if [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
  refresh='pprint info-go "Refreshing fonts"; fc-cache -f 2>&1'
fi

fonts_installed=${fonts_dir}/.dot
if [[ ! -f "${fonts_installed}" ]]; then
  pprint info-go "Installing fonts into ${fonts_dir}"
  cp $DOT/system/fonts/* ${fonts_dir}
  touch ${fonts_installed}
  sh -c "${refresh}"
fi

try pinstall brew ack
try pinstall brew coreutils
try pinstall brew grc
exit $TRY_CODE
