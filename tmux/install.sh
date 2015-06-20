#!/bin/bash

pinstall pip tmuxp
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
exit 0
