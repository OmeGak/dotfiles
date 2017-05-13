#!/usr/bin/env bash

if [[ "$OS" != "Darwin" ]]; then
  pprint step-error "Cask is only for Mac"
  exit 1
fi

# Get list of new casks
brew cask ls -1 > /tmp/cask-ls
new_casks=$(cat $DOT/cask/casks.txt | grep -v \# | grep -vwf /tmp/cask-ls)

# Install new casks
if [[ ! -z "${new_casks}" ]]; then
  brew cask install ${new_casks} --appdir=/Applications
fi

# Cleanup
$DOT/cask/ownerfix.sh
brew cask cleanup

exit 0
