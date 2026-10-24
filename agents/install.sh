#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

try pinstall brew claude-code@latest
try pinstall brew codex
try pinstall brew copilot-cli
try pinstall brew handy
try pinstall brew herdr
try pinstall brew peonping/tap/peon-ping
# peon-ping's banners: its overlay style hangs on macOS 15
try pinstall brew omegak/brewery/terminal-notifier-agentbox

# Link herdr plugins on every run: herdr keeps a copy of each manifest
pprint info-go "Linking herdr plugins"
logfile="/tmp/herdr-plugins.$DOT_TOPIC_LOGFILE_SUFFIX"
: > "${logfile}"
for plugin in "$DOT"/agents/dotagents/herdr/plugins/*/; do
  if ! herdr plugin link "${plugin%/}" >> "${logfile}" 2>&1; then
    pprint info-error "Failed to link $(basename "${plugin}")"
    TRY_CODE=1
  fi
done

# Link the shared Claude setup (skills, rules, settings) from dotagents
sudoplz -r "For Claude Code's managed settings"
pprint info-go "Installing dotagents"
if ! "$DOT/agents/dotagents/dotagents" install laptop > "/tmp/dotagents.$DOT_TOPIC_LOGFILE_SUFFIX" 2>&1; then
  pprint info-error "Failed to install dotagents"
  TRY_CODE=1
fi

exit $TRY_CODE
