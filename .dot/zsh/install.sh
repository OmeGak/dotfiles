#!/usr/bin/env bash

set -e

if [[ ! "$(zgrep "`which zsh`" /etc/shells)" ]]; then
  sudoplz -r "For adding zsh to valid shells"
  which zsh | sudo tee -a /etc/shells > /dev/null
fi
