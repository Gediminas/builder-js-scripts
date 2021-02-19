#!/usr/bin/env sh

DIRNAME="${BASH_SOURCE%[/\\]*}"
"$DIRNAME/build" wood debug

echo "Press ENTER to exit..."
read -r
