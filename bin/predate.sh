#!/bin/bash

while read line; do
  #echo "$(date +%F %H:%M:%S) $line"
  echo "$(date '+%Y-%m-%d %H:%M:%S') $line"
done
