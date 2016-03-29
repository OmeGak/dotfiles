#!/usr/bin/env bash
source $DOT/.dot/functions/try

try pinstall brew ack
try pinstall brew coreutils
try pinstall brew grc
try pinstall brew unrar

if [[ "$(uname -s)" == "Linux" ]]; then
  try pinstall apt xclip
fi


# -- Install missing fonts ----------------------------------------------------

fonts_dir="$HOME/Library/Fonts"
if [[ "$(uname -s)" == "Linux" ]]; then
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
    # Symlinking fonts is not supported in OSX
    cp "${font_src}" "$(target "${font_src}")"
  done
  sh -c "${refresh}"
fi

exit $TRY_CODE
