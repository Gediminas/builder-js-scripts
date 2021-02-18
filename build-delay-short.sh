#!/usr/bin/env sh

DIRNAME="${BASH_SOURCE%[/\\]*}"
"$DIRNAME/build" delay-short

echo "Press ENTER to exit..."
read -r
