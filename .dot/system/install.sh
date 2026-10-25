#!/usr/bin/env bash

set -e

if [[ "$OS" == "Linux" ]]; then
  sudoplz

  prun "Updating apt-get" sudo apt-get update -y -qq || true
  prun "Updating apt-get, fixing missing packages" sudo apt-get update --fix-missing -y -qq || true

  # Linuxbrew system dependencies
  pinstall apt build-essential
  pinstall apt python-setuptools
  pinstall apt ruby

  # Needed for Python
  pinstall apt libsqlite3-dev
fi
