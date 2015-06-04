#!/bin/bash

pinstall pip tmuxp
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "TMUX tools are installed"
exit 0
