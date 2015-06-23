#!/bin/bash

syspip install --upgrade pip ipython tmuxp wdb.server > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
if [[ $? != 0 ]]; then
  pprint info-error "Failed to install some packages"
  exit 1
fi

exit 0
