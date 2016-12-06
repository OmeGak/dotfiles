# Source: http://apple.stackexchange.com/a/199958/118122

# First compile
# gcc -o disable-capslock-delay disable-capslock-delay.c

# Find the right hidraw device
HIDDEVICE=$(dmesg | grep Apple | grep Keyboard | grep input0 | tail -1 | sed -e 's/.*hidraw\([[:digit:]]\+\).*/\/dev\/hidraw\1/')

# Send a "Report Feature" to the device
$DOT/system/keyboard/disable-capslock-delay $HIDDEVICE
