#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  brew install python > /tmp/brew-python.dot.log 2>&1
  pprint ok "Python freshly brewed"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sudo apt-get install python > /tmp/apt-get-python.dot.log 2>&1
  pprint ok "Python freshly installed"
else
  pprint error "Unrecognized OS"
  exit 0
fi

pprint ok "Python is ready"
exit 0
