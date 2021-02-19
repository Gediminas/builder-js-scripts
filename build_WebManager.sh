#!/usr/bin/env sh

DIRNAME="${BASH_SOURCE%[/\\]*}"
"$DIRNAME/build" WebManager

echo "Press ENTER to exit..."
read -r
