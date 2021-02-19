#!/usr/bin/env sh

DIRNAME="${BASH_SOURCE%[/\\]*}"
"$DIRNAME/build" install-js

echo "Press ENTER to exit..."
read -r
