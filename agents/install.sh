#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew claude
try pinstall brew codex
try pinstall brew copilot-cli
try pinstall brew handy
try pinstall brew herdr
# Re-link on every run: herdr stores a copy of the manifest, so a re-link is how manifest changes take effect (idempotent).
try herdr plugin link "$DOT/agents/herdr-plugins/tab-names" >/dev/null
try pinstall brew rtk

try pinstall npm ccstatusline

exit $TRY_CODE
