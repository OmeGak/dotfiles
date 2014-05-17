#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  brew install git hub > /tmp/brew-git.dot.log 2>&1
  pprint ok "Git freshly brewed"
elif [[ "$(uname -s)" == "Linux" ]]; then
  # TODO
  # sudo apt-get install git hub > /tmp/apt-get-git.dot.log 2>&1
  # pprint ok "Git freshly installed"
else
  pprint error "Unrecognized OS"
  exit 0
fi

pprint ok "Git is ready"
exit 0
