#!/usr/bin/env bash
# Source: http://apple.stackexchange.com/a/199958/118122

# First compile
# gcc -o disable-capslock-delay disable-capslock-delay.c

# To run on startup add next line to the root crontab (sudo crontab -e)
# @reboot /home/<user>/.dotfiles/system/keyboard/disable-capslock-delay.sh

# This script needs to run as sudo, so it cannot use $DOT
SCRIPTPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find the right hidraw device
HIDDEVICE=$(dmesg | grep Apple | grep Keyboard | grep input0 | tail -1 | sed -e 's/.*hidraw\([[:digit:]]\+\).*/\/dev\/hidraw\1/')

# Send a "Report Feature" to the device
$SCRIPTPATH/disable-capslock-delay $HIDDEVICE
