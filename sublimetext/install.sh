#!/usr/bin/env bash

sublime_dir="$HOME/Library/Application Support/Sublime Text 3"
if [[ "$(uname -s)" == "Linux" ]]; then
  sublime_dir="$HOME/.config/sublime-text-3"
fi

pkgcontrol="${sublime_dir}/Installed Packages/Package Control.sublime-package"
prefs_source="$DOT/sublimetext/User"
prefs_target="${sublime_dir}/Packages/User"

# Install Package Control
if [[ ! -e "${pkgcontrol}" ]]; then
  pprint info-go "Installing Package control"
  server_url="https://packagecontrol.io/Package%20Control.sublime-package"
  curl -fsSL --create-dirs -o "${pkgcontrol}" "${server_url}"
fi

# Link ST settings if necessary
if [[ ! $(checklink "${prefs_target}" "${prefs_source}") ]]; then
  pprint info-go "Importing your preferences"
  createlink "${prefs_source}" "${prefs_target}"
fi

pinstall pip flake8
[[ $? != 0 ]] && errors=true

pinstall npm jshint
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
exit 0
