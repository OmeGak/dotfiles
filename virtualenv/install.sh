#!/bin/bash

pinstall pip virtualenv $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

pinstall pip virtualenvwrapper $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "Virtualenv is installed"
exit 0
