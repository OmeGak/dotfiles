#!/usr/bin/env bash

if [[ "$OS" != "Darwin" ]]; then
  pprint step-error "Cask is only for Mac"
  exit 1
fi

# Get list of new casks
brew list --cask > /tmp/cask-list
new_casks=$(cat $DOT/brew/casks.txt | grep -v \# | grep -vwf /tmp/cask-list)

# Install new casks
if [[ -n "${new_casks}" ]]; then
  echo "${new_casks}" | xargs -L 1 brew install
fi

# Cleanup
brew cask cleanup

exit 0
