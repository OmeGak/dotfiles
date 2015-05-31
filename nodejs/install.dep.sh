#!/bin/bash

# Check for NodeJS install it from Homebrew
if [[ -z $(brew ls --versions node) ]]; then
  pprint step "Brewing NodeJS"
  brew install node > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to brew node"
    exit 1
  fi
fi

pprint ok "NodeJS is ready to rock"
exit 0
