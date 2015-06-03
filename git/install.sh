#!/bin/bash

pinstall brew git
[[ $? != 0 ]] && errors=true

pinstall brew hub
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "Git and Hub are installed"
exit 0
