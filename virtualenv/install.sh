#!/bin/bash

if [[ ! $(syspip show virtualenv) ]]; then
  pprint step "Installing virtualenv"
  syspip install --upgrade virtualenv > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install virtualenv"
    errors=true
  fi
fi

if [[ ! $(syspip show virtualenvwrapper) ]]; then
  pprint step "Installing virtualenvwrapper"
  syspip install --upgrade virtualenvwrapper > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install virtualenvwrapper"
    errors=true
  fi
fi

if [[ $errors == "true" ]]; then
  exit 1
fi

pprint ok "Virtualenv is installed"
exit 0
