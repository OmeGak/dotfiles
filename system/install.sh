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

# Install common tools
brew install ack coreutils grc > /tmp/brew.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
if [[ $? != 0 ]]; then
  pprint error "Failed to install some packages"
  exit 1
fi
pprint ok "System tools are ready"

exit 0
