#!/usr/bin/env bash

build_cfg() {
    local build_cfg="$1"
    local configs="$2"
    local platform="$3"
    local ide="$4"

    echo "## Building: \"$1\"  \"$2\"  \"$3\"  \"$4\""

    build_list="$WORK/project_list.txt"
    collect_builds="$REPO/Builder/local/php/collect_builds.php"

    build_list=$(realpath --no-symlinks $build_list)
    collect_builds=$(realpath --no-symlinks $collect_builds)

        TIMER_START=`date +%s%N`

    collect=$RECIPES/ware/php/collect_projects.php
    TTL 1 php "$collect" "$build_cfg" "$configs" "$platform" "$build_list"
    readarray -t projects < "$build_list"

        TIMER_END=$(date +%s%N)
        TIMER_SPAN=$(($TIMER_END-$TIMER_START))
        echo - | awk "{print $TIMER_SPAN/1000000000}"

    IFS=$'\n' projects=("${projects[@]}")

    for project in ${projects[@]}; do
        echo "$project"
    done

    # project_count=$(echo "${projects[@]}" | wc -l)
    project_count=$(echo "${projects[@]}" | wc -l)
    # echo "! Building $project_count project(s)"

    exit

    # REPO=$PWD
    # collect_cmake="$REPO/Builder/local/CMake/scripts/php/collect_cmake_files.php"
    # clean_cmake="$REPO/Builder/local/CMake/scripts/cmake/clean_cmake.cmake"


    build_list="$WORK/cmake_paths.txt"

    TTL 1 php "$collect_cmake" "$build_cfg" "$build_list"
    echo "$build_list"

    # cd ../../../bin
    while IFS=$'\r\n' read -r generation_path || [[ -n $generation_path ]]; do
        echo "GEN: $generation_path"
        # cd "$generation_path" || continue

        # echo ">> cmake \"$generation_path\" -G \"$generator\" -A \"$architecture\""
        # output=$(cmake "$generation_path" -G "$generator" -A "$architecture";)
        # echo "$output"

        # # # $pos = strpos($output, "CMakeOutput.log");
        # # # if( $pos !== false) {
        # # # 	_log_error("There were errors generating in $generate_path.");
        # # # }
        # # # else {
        # # # 	_log_to($command_log, "$output");
        # # # }

        # TTL 1 cmake -Dgeneration_path="$generation_path" -P "$clean_cmake"

    done <$build_list

    cd $REPO || exit
}

