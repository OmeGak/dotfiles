#!/usr/bin/env bash

source $DOT/.dot/functions/keepsudo

repo='install/master/install'
[[ "$OS" == "Linux" ]] && repo='linuxbrew/go/install'

# Check for Homebrew
if test ! $(which brew); then
  pprint info-go "Installing Homebrew"
  sudoplz
  script="def at_exit(*); end; $(curl -fsSL https://raw.githubusercontent.com/Homebrew/${repo})"
  yes | ruby -e "${script}" > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  [[ $? != 0 ]] && pprint info-error "Failed to install Homebrew" && exit 1
  # Disables `sudo -k` during the install so that keepsudo can keep sudo
  _brew_disable_sudo_k
fi

pprint info-ok "Homebrew is ready to brew -- Choo, choo!"

# Prepare Linuxbrew standalone
if [[ "$OS" == "Linux" ]]; then
  sh -c "$DOT/homebrew/linuxbrew-standalone.sh"
  [[ $? != 0 ]] && pprint info-error "Failed to make Homebrew standalone" && exit 1
fi

exit 0
