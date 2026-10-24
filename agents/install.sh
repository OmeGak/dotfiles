#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew claude
try pinstall brew codex
try pinstall brew copilot-cli
try pinstall brew handy
try pinstall brew herdr
# Re-link every plugin on every run: herdr stores a copy of the manifest, so a re-link is how manifest changes take effect (idempotent).
for plugin in "$DOT"/agents/dotagents/herdr/plugins/*/; do
  try herdr plugin link "${plugin%/}" >/dev/null
done

# Link the shared Claude setup (skills, rules, output styles, subagents) from the dotagents submodule.
try "$DOT/agents/dotagents/dotagents" install laptop

# peon-ping: dotagents' hook runs Homebrew's peon on ~/.openpeon, which
# links to openpeon.symlink here (config and sound pack), so neither
# peon-ping-setup nor its downloads are needed.
try pinstall brew peonping/tap/peon-ping
# Notification Center notifications: the overlay style hangs on macOS 15.
try pinstall brew terminal-notifier

exit $TRY_CODE
