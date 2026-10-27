#!/usr/bin/env bash

set -e

if [[ ! "$(zgrep "`which zsh`" /etc/shells)" ]]; then
  sudoplz -r "adding zsh to /etc/shells" || exit 0
  which zsh | sudo tee -a /etc/shells > /dev/null
fi
