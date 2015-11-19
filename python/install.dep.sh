#!/usr/bin/env bash

set -e

if [[ "$(uname -s)" == "Linux" ]]; then
  # Needed before compiling Python
  pinstall brew sqlite3
fi

pinstall brew python
pprint info-ok "Python is ready to fly"
