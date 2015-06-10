#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  repo='install/master/install'
elif [[ "$(uname -s)" == "Linux" ]]; then
  repo='linuxbrew/go/install'
else
  pprint warning "Unsupported OS"
  exit 0
fi

# Check for Homebrew
if test ! $(which brew); then
  pprint step "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/${repo})" < /dev/null > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install Homebrew"
    exit 1
  fi
fi

pprint ok "Homebrew is ready to brew -- Choo, choo!"
exit 0
