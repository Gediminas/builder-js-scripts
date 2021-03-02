#!/usr/bin/env bash

# Generates .mo language files from .po language
# Outputs to the same folder
# Usage: po2mo <path-to-po-files>

 po2mo() {
     files=$(find "$1" -name "*.po" -type f; echo .)
     line_count=$(($(printf "%s\n" "$files" | wc -l) - 1))

     echo "--------------------";
     echo "! $1";
     echo "! contains $line_count .po files";
     echo "--------------------";

     for pathPo in $files; do
         [ -f "$pathPo" ] || break
         path="${pathPo%.po}"
         pathMo="${path}.mo"
         name="${path##*/}"

         echo -n "Compiling $name..."

         output=$(msgfmt -o "$pathMo" "$path")

         if [ -z "$output" ]; then
             echo "OK"
         else
             echo "ERROR: program returned [$output]";
         fi
     done
}
