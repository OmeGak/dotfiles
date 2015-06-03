#!/bin/bash

if [[ "$(uname -s)" == "Darwin" ]]; then
  sublime_dir="$HOME/Library/Application Support/Sublime Text 3"
elif [[ "$(uname -s)" == "Linux" ]]; then
  sublime_dir="$HOME/.config/sublime-text-3"
else
  print error "Unrecognized OS"
  exit 0
fi

sublime_pkgcontrol="${sublime_dir}/Installed Packages/Package Control.sublime-package"
sublime_pkgs_dir="${sublime_dir}/Packages"

# Install Package Control if necessary
if [[ ! -e "${sublime_pkgcontrol}" ]]; then
  pprint step "Installing Package control"
  server_url="https://packagecontrol.io/Package%20Control.sublime-package"
  curl -fsSL -o "${sublime_pkgcontrol}" "${server_url}"
fi

# Link ST settings if necessary
if [[ ! -d "${sublime_pkgs_dir}/User.bak" ]]; then
  pprint step "Installing your preferences"
  mv "${sublime_pkgs_dir}/User" "${sublime_pkgs_dir}/User.bak"
  rm -rf "${sublime_pkgs_dir}/User"
  ln -snf "$DOT/sublimetext/User" "${sublime_pkgs_dir}/User"
fi

pinstall pip flake8 $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

pinstall npm jshint $DOT_TOPIC_LOGFILE_SUFFIX
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
pprint ok "SublimeText is ready to hack"
exit 0
