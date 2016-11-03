#!/usr/bin/env bash

sublime_dir="$HOME/Library/Application Support/Sublime Text 3"
if [[ "$(uname -s)" == "Linux" ]]; then
  sublime_dir="$HOME/.config/sublime-text-3"
fi

pkgcontrol="${sublime_dir}/Installed Packages/Package Control.sublime-package"
settings_source="$DOT/sublimetext/User"
settings_target="${sublime_dir}/Packages/User"

# Install Package Control
if [[ ! -e "${pkgcontrol}" ]]; then
  pprint info-go "Installing Package control"
  server_url="https://packagecontrol.io/Package%20Control.sublime-package"
  curl -fsSL --create-dirs -o "${pkgcontrol}" "${server_url}"
fi

# Link settings
if [[ ! $(checklink "${settings_target}" "${settings_source}") ]]; then
  pprint info-go "Installing settings"
  mksymlink "${settings_source}" "${settings_target}"
fi

pinstall pip flake8
[[ $? != 0 ]] && errors=true

pinstall pip flake8-docstrings
[[ $? != 0 ]] && errors=true

pinstall npm eslint
[[ $? != 0 ]] && errors=true

[[ ${errors} == "true" ]] && exit 1
exit 0
