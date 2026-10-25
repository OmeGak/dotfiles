#!/usr/bin/env bash
# Installs Homebrew (Linuxbrew on Linux) when there is none

installer='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

if ! command -v brew > /dev/null; then
  pprint info-go "Installing Homebrew"
  # The installer needs sudo for its prefix; dot-start keeps it alive
  sudoplz
  log="/tmp/$DOT_TOPIC_LOGFILE_SUFFIX"
  if ! script=$(curl -fsSL "${installer}") \
    || ! NONINTERACTIVE=1 bash -c "${script}" > "${log}" 2>&1; then
    pprint info-error "Failed to install Homebrew"
    exit 1
  fi
fi

exit 0
