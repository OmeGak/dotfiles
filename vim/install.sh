#!/usr/bin/env bash

# Headless (-es), so it runs unattended under prun: no screen, no stdin
try prun "Installing vim plugins" vim -es -u "$HOME/.vimrc" -i NONE -c PlugInstall -c qa
