#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

if [[ "$OS" != "Darwin" ]]; then
  pprint info-warn "Step skipped: iTerm is only available for macOS"
  exit 0
fi

try pinstall brew phook

exit $TRY_CODE
