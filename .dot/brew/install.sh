#!/usr/bin/env bash
# Installs Homebrew when there is none

installer='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

if ! command -v brew > /dev/null; then
  # The installer needs sudo for its prefix, and nothing installs without
  # Homebrew, so a run without root fails here rather than skip
  sudoplz -r "Homebrew's prefix" || exit 1
  if ! script=$(curl -fsSL "${installer}"); then
    pprint info-error "Couldn't fetch Homebrew's installer"
    exit 1
  fi
  NONINTERACTIVE=1 prun "Installing Homebrew" bash -c "${script}" || exit 1
fi

exit 0
