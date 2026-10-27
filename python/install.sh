#!/usr/bin/env bash

# One Python on the PATH, as ~/.local/bin/python: the version is named so a
# newer release never swaps it under a run. It does not follow
# .python-version; that file is for uv, in a venv it makes (uv venv, uv run)
try prun "Installing Python 3.13" uv python install --default 3.13
