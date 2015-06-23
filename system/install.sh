#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  fonts_dir="$HOME/Library/Fonts"
elif [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
  refresh='pprint info-go "Refreshing fonts"; fc-cache -f 2>&1'
else
  pprint info-error "Unrecognized OS"
  exit 0
fi

fonts_installed=${fonts_dir}/.dot

if [[ ! -f "${fonts_installed}" ]]; then
  pprint info-go "Installing fonts into ${fonts_dir}"
  cp $DOT/system/fonts/* ${fonts_dir}
  touch ${fonts_installed}
  sh -c "${refresh}"
fi

pinstall brew ack
[[ $? != 0 ]] && errors=true

pinstall brew coreutils
[[ $? != 0 ]] && errors=true

pinstall brew grc
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
exit 0
