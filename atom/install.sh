#!/usr/bin/env bash
source $DOT/.dot/functions/try

if [[ "$OS" == "Darwin" ]]; then
  try pinstall cask atom
fi

try pinstall brew ctags

# Linters
try pinstall brew shellcheck
try pinstall gem rubocop
try pinstall npm dockerlint
try pinstall npm eslint
try pinstall npm eslint-plugin-promise
try pinstall npm eslint-config-standard
try pinstall npm eslint-plugin-standard
try pinstall npm sass-lint
try pinstall pip flake8

exit $TRY_CODE
