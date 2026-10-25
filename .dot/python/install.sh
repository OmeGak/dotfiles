#!/usr/bin/env bash

set -e

# uv installs the Python command-line tools pinstall is asked for, with
# interpreters of its own; brew's python arrives as other formulae's dependency
pinstall brew uv
