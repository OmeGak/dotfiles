#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

# Linters
try pinstall brew hlint
try pinstall brew shellcheck
try pinstall gem rubocop
try pinstall npm dockerlint
try pinstall npm eslint
try pinstall npm eslint-plugin-promise
try pinstall npm eslint-plugin-react
try pinstall npm eslint-config-standard
try pinstall npm eslint-plugin-standard
try pinstall npm sass-lint
try pinstall pip3 flake8
try pinstall pip3 flake8-isort
try pinstall pip3 pydocstyle
try pinstall pip3 pylint

# FIXME: Must be installed locally in `~` with `npm install` until this issue is resolved
#        https://github.com/remarkjs/remark-lint/issues/165
# try pinstall npm remark-lint-list-item-indent
# try pinstall npm remark-lint-maximum-line-length
# try pinstall npm remark-lint-ordered-list-marker-value
# try pinstall npm remark-preset-lint-consistent
# try pinstall npm remark-preset-lint-recommended
# try pinstall npm remark-preset-lint-markdown-style-guide

# Link VSCodium settings
vscodium_settings_source="$DOT/dev/vscodium"
[[ "$OS" == "Darwin" ]] && vscodium_settings_target="$HOME/Library/Application Support/VSCodium/User" \
                        || (pprint info-warn "VSCodium settings not installed" && exit 1)
if [[ ! $(checklink "${vscodium_settings_target}" "${vscodium_settings_source}") ]]; then
  pprint info-go "Installing VSCodium settings"
  mksymlink "${vscodium_settings_source}" "${vscodium_settings_target}"
fi

exit $TRY_CODE
