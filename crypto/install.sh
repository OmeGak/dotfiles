#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew bitcoin

bitcoin_conf="bitcoin.conf"
bitcoin_conf_source="$DOT/crypto/${bitcoin_conf}"
bitcoin_conf_target="$HOME/Library/Application Support/Bitcoin/${bitcoin_conf}"

# Link bitcoin.conf
if [[ ! $(checklink "${bitcoin_conf_target}" "${bitcoin_conf_source}") ]]; then
  pprint info-go "Installing bitcoin.conf"
  mksymlink "${bitcoin_conf_source}" "${bitcoin_conf_target}"
fi

exit $TRY_CODE
