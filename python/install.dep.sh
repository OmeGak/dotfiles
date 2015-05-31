#!/bin/bash

# Check for Python install it from Homebrew (it comes with pip)
if [[ -z $(brew ls --versions python) ]]; then
  pprint step "Brewing Python"
  brew install python > /tmp/brew-python.dot.log 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install python"
    exit 1
  fi
fi

pprint ok "Python is ready to fly"
exit 0
