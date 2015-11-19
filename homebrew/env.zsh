if [[ "$(uname -s)" == "Linux" ]]; then
  # Make sure brew uses brew-compiled gcc if present
  export HOMEBREW_CC=gcc
fi
