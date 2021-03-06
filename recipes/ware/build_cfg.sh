#!/usr/bin/env bash

__matching_project_data() {
    local path_dsp="$1"
    local configs="$2"
    local platform="$3"
    IFS=, configs=("${configs[@]}")
    for config in $configs; do
        if [[ ! -f "$path_dsp" ]]; then
            echo "ERROR: '$path_dsp' does not exist" >&2
            continue
        fi
        local needle="<ProjectConfiguration Include=\"$config|$platform\">"
        local found=$(grep "$needle" < "$path_dsp")
        if [[ -n $found ]]; then
            echo "$path_dsp|$config|$platform"
        fi
    done
}

__project_list() {
    local build_cfg="$1"
    local configs="$2"
    local platform="$3"
    local build_cfg=$(realpath --no-symlinks $1)
    local ROOT="${build_cfg%[/\\]*}"
    local lines
    readarray -t lines < "$build_cfg"
    for line in ${lines[@]}; do
        line=${line//[\ $'\r']}
        if [[ -z "$line" ]]; then
           continue # Skip empty lines
        fi
        if [[ $str =~ ^# ]]; then
           continue # Skip commented lines
        fi
        if [[ $str =~ ^// ]]; then
           continue # Skip commented lines
        fi
        path=$(realpath --no-symlinks "$ROOT/$line")
        if [[ $path =~ ".cfg" ]]; then
            __project_list "$path" "$configs" "$platform"
        else
            __matching_project_data "$path" "$configs" "$platform"
        fi
    done
}

build_cfg() {
    local build_cfg="$1"
    local configs="$2"
    local platform="$3"
    local ide="$4"

    echo "## Processing: \"$1\"  \"$2\"  \"$3\"  \"$4\""

    __project_list "$build_cfg" "$configs" "$platform"
    exit

    projects=$(__project_list "$build_cfg" "$configs" "$platform")

    IFS=$'\n' projects=("${projects[@]}")

    for project in $projects; do
        echo "PROJ: $project"
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

