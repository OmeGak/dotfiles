#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  brew install python 2> /tmp/brew-python
  pprint ok "Python freshly brewed"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sudo apt-get install python > /tmp/apt-get-python
  pprint ok "Python freshly installed"
else
  pprint error "Unrecognized OS"
  exit 1
fi

exit 0
