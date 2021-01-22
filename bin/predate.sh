#!/bin/bash

echo "PREDATE"

while IFS= read -r line; do
  #echo "$(date +%F %H:%M:%S) $line"
  echo "$(date '+%Y-%m-%d %H:%M:%S') $line"
  # printf "%s: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$line"
done
