#!/usr/bin/env bash

# gh reads public repos without a login; anything else needs one, once.
# `gh auth token` reads the stored token without the network
if ! gh auth token &> /dev/null; then
  pprint info-warn "gh is not logged in (gh auth login)"
fi
