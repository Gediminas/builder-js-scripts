#!/usr/bin/env sh

build_cfg() {
    build_cfg_file="$1"
    build_configs="$2"
    platform="$3"

    echo "# Processing: \"$1\"  \"$2\"  \"$3\"  \"$4\" / HDR"
    echo ">> some-command  / CMD"
    echo "This is some command output to stdout / SKIPPED"
    echo "This is some command output to stdout / SKIPPED"
    echo "This is some command output to stdout / SKIPPED"
    echo "This is some command output to stdout / SKIPPED"
    echo "This is some command output to stderr / SKIPPED" >&2

    echo ERROR: $1 made an error / ERR
    echo Some not standard fatal error that should be caught / ERR
    echo "fatal: internal"
    echo WARNING: $1 is suspicious / WRN
    echo Some lite error/ WRN
    echo "Something to highlight"
    echo Some not standard lite error / SKIPPED
    echo Fake match \$match / SKIPPED
    echo Fake match $match / SKIPPED

    # echo !!! ERROR: "\"$1\" error caught
    # echo !!! WARNING: "\"$1\" warning cought
}
