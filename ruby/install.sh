#!/bin/bash

# Check if rbenv is not installed
if [[ -z $(brew ls --versions rbenv) ]]; then
  pprint step "Brewing rbenv"
  brew install rbenv > /tmp/rbenv.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install rbenv"
    errors=true
  fi
fi

if [[ -z $(brew ls --versions ruby-build) ]]; then
  pprint step "Brewing ruby-build"
  brew install ruby-build > /tmp/ruby-build.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install ruby-build"
    errors=true
  fi
fi

if [[ $errors == "true" ]]; then
  exit 1
fi

pprint ok "Ruby magic is installed"
exit 0
