#!/bin/bash

pinstall brew rbenv
[[ $? != 0 ]] && errors=true

pinstall brew ruby-build
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "Ruby magic is installed"
exit 0
