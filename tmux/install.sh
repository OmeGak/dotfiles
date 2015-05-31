#!/bin/bash

# Install tmuxp
if [[ ! $(syspip show tmuxp) ]]; then
  pprint step "Installing tmuxp"
  syspip install --upgrade tmuxp > /tmp/tmuxp.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install tmuxp"
    exit 1
  fi
fi

pprint ok "TMUX tools are installed"
exit 0
