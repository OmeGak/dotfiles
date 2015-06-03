#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  fonts_dir="$HOME/Library/Fonts"
elif [[ "$(uname -s)" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
else
  pprint error "Unrecognized OS"
  exit 0
fi

# TODO: check if fonts were already installed
cp $DOT/system/fonts/* ${fonts_dir}
pprint ok "Installed fonts into ${fonts_dir}"

# Uncomment if fonts are not available
# echo "Refreshing fonts cache"
# fc-cache -f

pinstall brew ack $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

pinstall brew coreutils $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

pinstall brew grc $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "System tools are ready"
exit 0
