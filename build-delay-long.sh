#!/usr/bin/env sh

DIRNAME="${BASH_SOURCE%[/\\]*}"
"$DIRNAME/build" delay-long

echo "Press ENTER to exit..."
read -r
