#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

# Linters
try pinstall brew hlint
try pinstall brew shellcheck
try pinstall npm dockerlint
try pinstall npm eslint
try pinstall npm eslint-plugin-promise
try pinstall npm eslint-plugin-react
try pinstall npm eslint-config-standard
try pinstall npm eslint-plugin-standard
try pinstall npm sass-lint
try pinstall pip flake8
try pinstall pip flake8-isort
try pinstall pip pydocstyle
try pinstall pip pylint

# FIXME: Must be installed locally in `~` with `npm install` until this issue is resolved
#        https://github.com/remarkjs/remark-lint/issues/165
# try pinstall npm remark-lint-list-item-indent
# try pinstall npm remark-lint-maximum-line-length
# try pinstall npm remark-lint-ordered-list-marker-value
# try pinstall npm remark-preset-lint-consistent
# try pinstall npm remark-preset-lint-recommended
# try pinstall npm remark-preset-lint-markdown-style-guide

link_vscode_settings() {
  local build="$1"
  local settings_target="$2"
  local settings_source="$DOT/dev/vscode"
  if [[ "$OS" != "Darwin" ]]; then
    pprint info-warn "${build} settings not installed"
    exit 1
  fi
  if [[ ! $(checklink "${settings_target}" "${settings_source}") ]]; then
    pprint info-go "Installing ${build} settings"
    mksymlink "${settings_source}" "${settings_target}"
  fi
}

# Link VSCode settings
link_vscode_settings 'VSCode' "$HOME/Library/Application Support/Code/User"

# Install extensions
if [[ $(which code) ]]; then
  pprint info-go "Installing VSCode extensions"
  xargs -L 1 code --install-extension > /dev/null < "${DOT}/dev/vscode.ext"
fi

exit $TRY_CODE
