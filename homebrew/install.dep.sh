#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  repo='install/master/install'
elif [[ "$(uname -s)" == "Linux" ]]; then
  repo='linuxbrew/go/install'
else
  pprint info-warn "Unsupported OS"
  exit 0
fi

# Check for Homebrew
if test ! $(which brew); then
  pprint info-go "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/${repo})" < /dev/null > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint info-error "Failed to install Homebrew"
    exit 1
  fi
fi

pprint info-ok "Homebrew is ready to brew -- Choo, choo!"
exit 0
