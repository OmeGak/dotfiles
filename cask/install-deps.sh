#!/bin/bash

export ZSH=$HOME/.dotfiles
cask_dir=$ZSH/cask

if [[ "$(uname -s)" != "Darwin" ]]; then
  pprint error "Unsupported OS"
  exit 0
fi

# Check for Cask
if test ! $(which brew-cask); then
  brew install caskroom/cask/brew-cask > /tmp/brew-cask.dot.log 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install Cask"
    exit 1
  fi
  brew tap caskroom/versions > /tmp/brew-cask-versions.dot.log 2>&1
  pprint step "Cask freshly brewed"
fi

# Get list of new casks
brew cask ls -1 > /tmp/cask-ls
new_casks=$(cat $cask_dir/casks.txt | grep -v \# | grep -vwf /tmp/cask-ls)

# Install new casks
if [[ ! -z "$new_casks" ]]; then
  brew cask install $new_casks --appdir=/Applications
fi

# Cleanup
$ZSH/cask/ownerfix.sh
brew cask cleanup
