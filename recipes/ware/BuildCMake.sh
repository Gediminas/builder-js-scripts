#!/usr/bin/env bash

BuildCMake () {
    build_cfg_file="$1"
    generator="$2"
    architecture="$3"

    REPO=$PWD
    collect_cmake="$REPO/Builder/local/CMake/scripts/php/collect_cmake_files.php"
    clean_cmake="$REPO/Builder/local/CMake/scripts/cmake/clean_cmake.cmake"
    build_list="$REPO/Builder/local/temp/cmake_paths.txt"
    cmake="$REPO/Builder/local/CMake/bin/cmake";
    # cmake=cmake

    echo "================="
    echo "build_cfg_file = $build_cfg_file"
    echo "generator = $generator"
    echo "architecture = $architecture"
    echo "curdir = $curdir"

    echo ">> php $collect_cmake $build_cfg_file $build_list"
    php "$collect_cmake" "$build_cfg_file" "$build_list"

    while IFS=$'\r\n' read -r generate_path || [[ -n $generate_path ]]; do
        cd "$generate_path" || continue

        echo "Generating in $generate_path"

        echo ">> $cmake $generate_path -G $generator -A $architecture"
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
