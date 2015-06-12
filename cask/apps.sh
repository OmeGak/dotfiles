#!/bin/bash

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint fail "This is not a Mac"
  exit 1
fi

if [[ ! $(which brew-cask) ]]; then
  pprint fail "Cask is not installed"
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
