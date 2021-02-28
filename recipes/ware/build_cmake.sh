#!/usr/bin/env bash

BuildCMake () {
    build_cfg="$1"
    generator="$2"
    architecture="$3"

    collect_cmake="Builder/local/CMake/scripts/php/collect_cmake_files.php"
    clean_cmake="Builder/local/CMake/scripts/cmake/clean_cmake.cmake"
    build_list="$WORK/cmake_paths.txt"

    echo "================="
    echo "build_cfg = $build_cfg"
    echo "generator = $generator"
    echo "architecture = $architecture"

    TTL 1 php "$collect_cmake" "$build_cfg" "$build_list"

    bak_dir=$PWD
    cd ../../../bin
    while IFS=$'\r\n' read -r generation_path || [[ -n $generation_path ]]; do
        # echo "Generating in $generation_path"
        # cd "$generation_path" || continue

        echo ">> cmake \"$generation_path\" -G \"$generator\" -A \"$architecture\""
        output=$(cmake "$generation_path" -G"$generator" -A"$architecture";)
        echo "$output"

        # # $pos = strpos($output, "CMakeOutput.log");
        # # if( $pos !== false) {
        # # 	_log_error("There were errors generating in $generate_path.");
        # # }
        # # else {
        # # 	_log_to($command_log, "$output");
        # # }

        # TTL 1 cmake -Dgeneration_path="$generation_path" -P "$clean_cmake"

    done <$build_list
    cd $bak_dir || exit
}
