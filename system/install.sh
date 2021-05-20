#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew bat
try pinstall brew coreutils
try pinstall brew dnsmasq
try pinstall brew fd
try pinstall brew glances
try pinstall brew grc
try pinstall brew make
try pinstall brew openssl
try pinstall brew ripgrep
try pinstall brew unar
try pinstall brew wget

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
