#!/usr/bin/env bash

source $DOT/.dot/dot/functions/keepsudo

[[ "$OS" == "Darwin" ]] && repo='Homebrew' \
                        || repo='Linuxbrew'

# Check for Homebrew
if ! command -v brew > /dev/null; then
  pprint info-go "Installing Homebrew"
  sudoplz
  script="def at_exit(*); end; $(curl -fsSL https://raw.githubusercontent.com/${repo}/install/master/install)"
  yes | ruby -e "${script}" > /tmp/$DOT_TOPIC_LOGFILE_SUFFIX 2>&1
  [[ $? != 0 ]] && pprint info-error "Failed to install Homebrew" && exit 1
  # Disables `sudo -k` during the install so that keepsudo can keep sudo
  _brew_disable_sudo_k
fi

pprint info-ok "Homebrew is ready to brew -- Choo, choo!"
exit 0
