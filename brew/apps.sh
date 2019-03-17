#!/usr/bin/env bash

if [[ "$OS" != "Darwin" ]]; then
  pprint step-error "Cask is only for Mac"
  exit 1
fi

# Get list of new casks
brew cask list > /tmp/cask-list
new_casks=$(cat $DOT/brew/casks.txt | grep -v \# | grep -vwf /tmp/cask-list)

# Install new casks
if [[ ! -z "${new_casks}" ]]; then
  brew cask install ${new_casks}
fi

# Cleanup
brew cask cleanup

exit 0
