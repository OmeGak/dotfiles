#!/bin/bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint warning "Step skipped: This is not a Mac"
  exit 0
fi

# Check for Cask
if [[ ! $(which brew-cask) ]]; then
  pprint step "Installing brew-cask"
  brew install caskroom/cask/brew-cask > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install brew-cask"
    exit 1
  fi
fi

# Check if caskroom/versions is tapped
if [[ -z $(brew tap | grep caskroom/versions) ]]; then
  pprint step "Tapping caskroom/versions formulas"
  brew tap caskroom/versions > /tmp/tap.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to tap caskroom/versions"
    exit 1
  fi
fi

exit 0
