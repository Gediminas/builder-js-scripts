#!/usr/bin/env sh

DIRNAME="${BASH_SOURCE%[/\\]*}"
"$DIRNAME/build" wood release

echo "Press ENTER to exit..."
read -r
