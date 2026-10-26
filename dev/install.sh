#!/usr/bin/env bash

# vscode.ext is a dump of `code --list-extensions`, so it stays a file of its
# own; the code driver installs the ones missing in one call
# shellcheck disable=SC2046
pinstall code $(< "$DOT/dev/vscode.ext")
