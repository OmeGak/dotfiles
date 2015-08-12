#!/usr/bin/env bash

set -e

if [[ "$(uname -s)" == "Linux" ]]; then
  sudoplz

  pinstall apt build-essential
  pinstall apt ruby
  pinstall apt zsh

  # Needed for python to compile with sugar
  pinstall apt libbz2-dev
  pinstall apt libreadline-dev
  pinstall apt libsqlite3-dev

  # Needed for brew-git
  pinstall apt libx11-dev
  pinstall apt libcurl4-gnutls-dev

  # Needed for brew-ruby-build
  pinstall apt m4
fi
