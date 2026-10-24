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

# peon-ping: the setup links its files and skills and downloads the packs;
# its hooks come from dotagents' managed settings, so the copies the setup
# writes into settings.json go, or every event would play twice.
try pinstall brew peonping/tap/peon-ping
# Notification Center notifications: the overlay style hangs on macOS 15.
try pinstall brew terminal-notifier
try peon-ping-setup --packs=cute-minimal,glados,peasant,peon,sc_battlecruiser,sc_scv
settings=~/.claude/settings.json
jq '(.hooks // {}) |= (map_values(map(select(any(.hooks[]; .command | contains("hooks/peon-ping/peon.sh")) | not))) | with_entries(select(.value != [])))' \
  "$settings" > "$settings.tmp" && mv "$settings.tmp" "$settings" || TRY_CODE=1
# After the setup: on a fresh machine it copies its default config, through a link too.
try ln -sf "$DOT/agents/peon-ping/config.json" ~/.claude/hooks/peon-ping/config.json

exit $TRY_CODE
