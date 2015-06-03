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

# Install flake8 linter
if [[ ! $(syspip show flake8) ]]; then
  pprint step "Installing flake8"
  syspip install --upgrade flake8 > /tmp/flake8.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install flake8"
    errors=true
  fi
fi

# Install jshint linter
if [[ ! $(npm -g list jshint) ]]; then
  pprint step "Installing jshint"
  npm -g install jshint > /tmp/npm.$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  if [[ $? != 0 ]]; then
    pprint error "Failed to install jshint"
    errors=true
  fi
fi

if [[ $errors == "true" ]]; then
  exit 1
fi

pprint ok "SublimeText is ready to hack"
exit 0
