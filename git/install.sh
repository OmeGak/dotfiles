#!/bin/bash

# Check for Git install it from Homebrew (latest version FTW)
if [[ -z $(brew ls --versions git) ]]; then
  pprint step "Brewing Git"
  brew install git > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to brew Git"
    errors=true
  fi
fi

# Check for Hub and install it (for GitHub magic)
if [[ -z $(brew ls --versions hub) ]]; then
  pprint step "Brewing Hub"
  brew install hub > /tmp/hub.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to brew hub"
    errors=true
  fi
fi

if [[ $errors == "true" ]]; then
  exit 1
fi

pprint ok "Git and Hub are installed"
exit 0
