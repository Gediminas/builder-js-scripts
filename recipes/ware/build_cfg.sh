#!/usr/bin/env bash

build()
{
    prj=$1
    config=$2
    platform=$3
    build=$4 || "rebuild"

    echo "### building $prj / $config / $platform"

	exe='c:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe'

	$exe "$prj" //m //v:m //t:$build //p:PlatformToolset=v142 //p:Configuration="$config" //p:Platform="$platform"
}

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
        echo -n "~ span: "
        echo - | awk "{print $TIMER_SPAN/1000000000}"

    IFS=$'\n' projects=("${projects[@]}")

    project_count=${#projects[@]}
    echo "! Building $project_count project(s)"

    for project_data in ${projects[@]}; do
        IFS='|' read -ra data <<< "$project_data"
        build "${data[0]}" "${data[1]}" "${data[2]}" "build"
    done
}
