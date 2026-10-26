#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

# Wire the herdr plugins on every run: herdr keeps a copy of each manifest.
# Not "linking", which is dot link's word for a symlink
for plugin in "$DOT"/agents/dotagents/herdr/plugins/*/; do
  try prun "Wiring herdr plugin $(basename "${plugin}")" herdr plugin link "${plugin%/}"
done

# Link the shared Claude setup (skills, rules, settings) from dotagents
sudoplz -r "For Claude Code's managed settings"
try prun "Installing dotagents" "$DOT/agents/dotagents/dotagents" install laptop

exit $TRY_CODE
