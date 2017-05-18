#!/usr/bin/env bash

set -e

if [[ "$OS" == "Linux" ]]; then
  sudoplz

  pprint info-go "Updating apt-get"
  sudo apt-get update -y -qq 2> /dev/null || true
  sudo apt-get update --fix-missing -y -qq 2> /dev/null || true

  # Linuxbrew system dependencies
  pinstall apt build-essential
  pinstall apt python-setuptools
  pinstall apt ruby

  # Needed for Python
  pinstall apt libsqlite3-dev
fi
