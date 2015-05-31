#!/bin/bash
#
# Installs Python global sweetness

syspip install --upgrade pip virtualenv virtualenvwrapper ipython tmuxp flake8 wdb.server > /tmp/pip-install.dot.log 2>&1
if [[ $? != 0 ]]; then
  pprint error "Failed to install Python global packages"
  exit 1
fi
