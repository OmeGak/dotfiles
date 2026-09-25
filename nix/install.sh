#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

# TODO: install nix here once there's a stable way to do it unattended
#       Upstream's installer is interactive and writes to /etc, and there's no
#       brew formula or cask. Until then, install by hand: https://nixos.org/download

exit $TRY_CODE
