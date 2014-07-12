#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  brew install node > /tmp/brew-node.dot.log 2>&1
  pprint ok "NodeJS freshly brewed"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sudo apt-get install python-software-properties > /tmp/apt-get-python-software-properties.dot.log 2>&1
  sudo add-apt-repository ppa:chris-lea/node.js > /tmp/add-apt-repository-nodejs.dot.log 2>&1
  sudo apt-get update > /tmp/apt-get-update.dot.log 2>&1
  sudo apt-get install nodejs > /tmp/apt-get-nodejs.dot.log 2>&1
  pprint ok "NodeJS freshly installed"
  sudo="sudo"
else
  pprint error "Unrecognized OS"
  exit 0
fi

$sudo npm install -g jshint > /tmp/npm-install.dot.log 2>&1
if [[ $? != 0 ]]; then
  pprint error "Failed to install NodeJS global packages"
  exit 1
fi

pprint ok "NodeJS is ready to rock"
exit 0
