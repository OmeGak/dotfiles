#!/bin/bash

pinstall pip virtualenv
[[ $? != 0 ]] && errors=true

pinstall pip virtualenvwrapper
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "Virtualenv is installed"
exit 0
