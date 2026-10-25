#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

# Linters
try pinstall brew grex
try pinstall brew hlint
try pinstall brew mise
try pinstall brew shellcheck
try pinstall brew tokei
try pinstall npm dockerlint
try pinstall npm eslint
try pinstall npm eslint-plugin-promise
try pinstall npm eslint-plugin-react
try pinstall npm eslint-config-standard
try pinstall npm eslint-plugin-standard
try pinstall npm sass-lint

# FIXME: Must be installed locally in `~` with `npm install` until this issue is resolved
#        https://github.com/remarkjs/remark-lint/issues/165
# try pinstall npm remark-lint-list-item-indent
# try pinstall npm remark-lint-maximum-line-length
# try pinstall npm remark-lint-ordered-list-marker-value
# try pinstall npm remark-preset-lint-consistent
# try pinstall npm remark-preset-lint-recommended
# try pinstall npm remark-preset-lint-markdown-style-guide

# Install extensions
if [[ $(which code) ]]; then
  # One code call with an --install-extension per line of vscode.ext
  # shellcheck disable=SC2046
  try prun "Installing VS Code extensions" code $(sed 's/^/--install-extension /' "${DOT}/dev/vscode.ext")
fi

exit $TRY_CODE
