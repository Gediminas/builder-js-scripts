#!/usr/bin/env bash

BuildCMake () {
    build_cfg="$1"
    generator="$2"
    architecture="$3"

    repo=$PWD
    collect_cmake="$repo/Builder/local/CMake/scripts/php/collect_cmake_files.php"
    clean_cmake="$repo/Builder/local/CMake/scripts/cmake/clean_cmake.cmake"
    build_list="$repo/Builder/local/temp/cmake_paths.txt"
    cmake="$repo/Builder/local/CMake/bin/cmake";

    echo "---"
    echo "~ PHP"
    php --version
    echo "---"
    echo "~ cmake"
    cmake.cmd --version
    echo "---"
    exit

    echo "================="
    echo "build_cfg = $build_cfg"
    echo "generator = $generator"
    echo "architecture = $architecture"
    echo "curdir = $curdir"

    php "$collect_cmake" "$build_cfg" "$build_list"

    while IFS=$'\r\n' read -r generate_path || [[ -n $generate_path ]]; do
    cd "$generate_path" || continue

    echo "Generating in $generate_path"

    output=$($cmake "$generate_path" -G "$generator" -A "$architecture";)

    echo "$output"
    # $pos = strpos($output, "CMakeOutput.log");
    # if( $pos !== false) {
    # 	_log_error("There were errors generating in $generate_path.");
    # }
    # else {
    # 	_log_to($command_log, "$output");
    # }

    $cmake -Dgeneration_path="$generate_path" -P $clean_cmake

    done <$build_list

    cd $curdir || exit
}
