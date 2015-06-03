#!/bin/bash

pinstall brew rbenv $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

pinstall brew ruby-build $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "Ruby magic is installed"
exit 0
