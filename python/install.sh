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

syspip install --upgrade pip virtualenv virtualenvwrapper ipython flake8 wdb.server > /tmp/pip-install.dot.log 2>&1
if [[ $? != 0 ]]; then
  pprint error "Failed to install Python global packages"
  exit 1
fi

pprint ok "Python is ready to fly"
exit 0
