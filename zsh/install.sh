#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew zsh
try pinstall brew zplug

if [[ ! "$(zgrep "`which zsh`" /etc/shells)" ]]; then
  sudoplz -r "For adding zsh to valid shells"
  which zsh | sudo tee -a /etc/shells > /dev/null
fi

exit $TRY_CODE
