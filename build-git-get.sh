#!/usr/bin/env sh

DIRNAME="${BASH_SOURCE%[/\\]*}"
"$DIRNAME/build" git-get

echo "Press ENTER to exit..."
read -r
