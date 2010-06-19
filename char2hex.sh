#!/bin/bash
#
# Usage: char2hex.sh [STRINGS]
#
# Convert strings to hex expression.
#

echo -n $* |hexdump -e '/1 "0x%02x, "'
echo 0x00
