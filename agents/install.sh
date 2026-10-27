#!/usr/bin/env bash

# Wire the herdr plugins on every run: herdr keeps a copy of each manifest.
# Not "linking", which is dot link's word for a symlink
for plugin in "$DOT"/agents/dotagents/herdr/plugins/*/; do
  try prun "Wiring herdr plugin $(basename "${plugin}")" herdr plugin link "${plugin%/}"
done

# Link the shared Claude setup (skills, rules, settings) from dotagents; it
# writes Claude Code's managed settings as root when they change
if sudoplz -r "Claude Code's managed settings"; then
  try prun "Installing dotagents" "$DOT/agents/dotagents/dotagents" install laptop
fi
