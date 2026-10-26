#!/usr/bin/env bash

# Make sure gnupg is not linked as it will collide with GPGTools
brew unlink gnupg > /dev/null 2>&1 || true
