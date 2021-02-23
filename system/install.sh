#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew ack
try pinstall brew coreutils
try pinstall brew direnv
try pinstall brew dnsmasq
try pinstall brew exercism
try pinstall brew grc
try pinstall brew httpie
try pinstall brew jupyter
try pinstall brew make
try pinstall brew openssl
try pinstall brew pandoc
try pinstall brew pass
try pinstall brew speedtest-cli
try pinstall brew unrar
try pinstall brew wget
try pinstall brew youtube-dl
try pinstall gem boom
try pinstall pip3 xkcdpass

# fonts
try pinstall brew font-sauce-code-pro-nerd-font
try pinstall brew font-source-code-pro

if [[ "$OS" == "Linux" ]]; then
  try pinstall apt xclip
fi

if [[ "$OS" == "Darwin" ]]; then
  # Make sure gnupg is not linked as it will collide with GPGTools
  brew unlink gnupg > /dev/null 2>&1
fi


# -- Create expected directories -----------------------------------------------

mkdir -p ${HOME}/Code


# -- Create other symlinks -----------------------------------------------------

source="$DOT/system/dnsmasq.conf"
target="/usr/local/etc/dnsmasq.conf"
if [[ ! $(checklink "${target}" "${source}") ]]; then
  pprint info-go "Installing dnsmasq configuration"
  mksymlink "${source}" "${target}"
fi

# Install macOS keybindings to prevent undesired beeps
# Source: https://github.com/adobe/brackets/issues/2419#issuecomment-186619537
if [[ "$OS" == "Darwin" ]]; then
  source="$DOT/system/keyboard/DefaultKeyBinding.dict"
  target="$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
  if [[ ! $(checklink "${target}" "${source}") ]]; then
    pprint info-go "Fixing weird keyboard beeps on macOS"
    mksymlink "${source}" "${target}"
  fi
fi

exit $TRY_CODE
