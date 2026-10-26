#!/usr/bin/env bash
# Installs Homebrew when there is none

installer='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

if ! command -v brew > /dev/null; then
  # The installer needs sudo for its prefix; dot-start keeps it alive
  sudoplz
  if ! script=$(curl -fsSL "${installer}"); then
    pprint info-error "Couldn't fetch Homebrew's installer"
    exit 1
  fi
  NONINTERACTIVE=1 prun "Installing Homebrew" bash -c "${script}" || exit 1
fi

exit 0
