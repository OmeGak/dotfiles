#!/usr/bin/env bash

set -e

if [[ "$(uname -s)" == "Linux" ]]; then
  sudoplz

  pprint info-go "Updating apt-get"
  sudo apt-get update -y -qq 2> /dev/null || true
  sudo apt-get update --fix-missing -y -qq 2> /dev/null || true

  # Linuxbrew system dependencies
  pinstall apt build-essential
  pinstall apt curl
  pinstall apt g++
  pinstall apt m4
  pinstall apt ruby
  pinstall apt texinfo
  pinstall apt libbz2-dev
  pinstall apt libcurl4-openssl-dev
  pinstall apt libexpat1-dev
  pinstall apt libncurses5-dev
  pinstall apt zlib1g-dev
  pinstall apt gawk
  pinstall apt make
  pinstall apt patch
  pinstall apt tcl

  # Needed for Python
  pinstall apt libsqlite3-dev
  pinstall apt libdbus-1-dev
  pinstall apt libdbus-glib-1-dev
fi
