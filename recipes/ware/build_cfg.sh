#!/usr/bin/env sh

CheckAddProjectConfig() {
    path_dsp="$1"
    configs="$2"
    platform="$3"
    IFS=, configs=("${configs[@]}")

    for config in $configs; do
         match="<ProjectConfiguration Include=\"$config|$platform\">"
         content=$(grep "$match" < "$path_dsp")
         if [ -n "$content" ]; then
             echo "$path_dsp|$config|$platform"
         fi
    done
}

CollectProjects() {
    build_cfg="$1"
    configs="$2"
    platform="$3"

    local build_cfg=$(realpath --no-symlinks $1)
    local ROOT="${build_cfg%[/\\]*}"
    # local ROOT=$(dirname "$build_cfg")

    readarray -t lines<"$build_cfg"

    for line in "${lines[@]}"; do
        if [[ "$line" == $'\r' ]]; then
           continue
        fi
        path=$(realpath --no-symlinks "$ROOT/$line")
        if [[ $path =~ ".cfg" ]]; then
            CollectProjects "$path" "$configs" "$platform"
        else
            CheckAddProjectConfig "$path" "$configs" "$platform"
        fi
    done
}

build_cfg() {
    build_cfg="$1"
    configs="$2"
    platform="$3"
    ide="$4"

    echo "# Processing: \"$1\"  \"$2\"  \"$3\"  \"$4\" / HDR"
    CollectProjects "$build_cfg" "$configs" "$platform"
    # projects=$()
    # project_count=$(wc -l < "${projects[@]}")

    # echo $project_count
    # echo $projects
    exit

    # REPO=$PWD
    # collect_cmake="$REPO/Builder/local/CMake/scripts/php/collect_cmake_files.php"
    # clean_cmake="$REPO/Builder/local/CMake/scripts/cmake/clean_cmake.cmake"


    build_list="$WORK/cmake_paths.txt"

    TTL 1 php "$collect_cmake" "$build_cfg" "$build_list"
    echo "$build_list"

    # cd ../../../bin
    while IFS=$'\r\n' read -r generation_path || [[ -n $generation_path ]]; do
        echo "$generation_path"
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

