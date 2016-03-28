#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew vim
if [[ $TRY_CODE == 0 ]]; then
  pprint info-go "Checking vim plugins"
  vim +PlugInstall +qall
fi

exit $TRY_CODE
