#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew ack
try pinstall brew coreutils
try pinstall brew direnv
try pinstall brew exercism
try pinstall brew grc
try pinstall brew httpie
try pinstall brew jupyter
try pinstall brew lolcat
try pinstall brew make
try pinstall brew pandoc
try pinstall brew pass
try pinstall brew speedtest-cli
try pinstall brew unrar
try pinstall brew wget
try pinstall brew youtube-dl
try pinstall gem boom
try pinstall pip3 xkcdpass

if [[ "$OS" == "Linux" ]]; then
  try pinstall apt xclip
fi

if [[ "$OS" == "Darwin" ]]; then
  # Make sure gnupg is not linked as it will collide with GPGTools
  brew unlink gnupg > /dev/null 2>&1
fi


# -- Create expected directories -----------------------------------------------

mkdir -p ${HOME}/Code


# -- Install missing fonts ----------------------------------------------------

fonts_dir="$HOME/Library/Fonts"
if [[ "$OS" == "Linux" ]]; then
  fonts_dir="$HOME/.fonts"
  refresh='pprint info-go "Refreshing fonts"; fc-cache -f 2>&1'
fi

target() {
  echo "${fonts_dir}/$(basename "$1")"
}

font_files=("$DOT/system/fonts/*")
missing_fonts=()
for font_src in ${font_files}; do
  if [[ ! -e "$(target "${font_src}")" ]]; then
    missing_fonts+=("${font_src}")
  fi
done

if [[ -n ${missing_fonts} ]]; then
  pprint info-go "Installing missing fonts into ${fonts_dir}"
  mkdir -p "${fonts_dir}"
  for font_src in ${missing_fonts[@]}; do
    # Symlinking fonts is not supported in macOS
    cp "${font_src}" "$(target "${font_src}")"
  done
  sh -c "${refresh}"
fi


# -- Fix quirks ----------------------------------------------------------------

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
