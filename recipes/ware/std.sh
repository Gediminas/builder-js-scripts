#!/usr/bin/env bash

PrepareFolderTree () {
    WORK="$PWD"

    if [[ $WORK =~ work_debug$ ]]; then
        cd ../       1>/dev/null || exit
    else
        cd ../../../ 1>/dev/null || exit
    fi

    mkdir -p ../../bin && pushd "$_" 1>/dev/null || exit
        PATH=$PWD/gettext_tools:$PATH
        PATH=$PWD:$PATH
    popd 1>/dev/null || exit

    mkdir -p ./data && pushd "$_" 1>/dev/null || exit
        DATA="$PWD"
    popd 1>/dev/null || exit

    mkdir -p ./repo && pushd "$_" 1>/dev/null || exit
        REPO="$PWD"
    popd 1>/dev/null || exit

    cd "$WORK" 1>/dev/null || exit
}

PrintFolders () {
    echo "~ DATA: $DATA"
    echo "~ REPO: $REPO"
    echo "~ WORK: $WORK"
}

PrintSystemInfo () {
    echo "! System Info:"
    echo -n "! * "
    which php
    echo -n "!   * "
    php --version | head -n 1

    echo -n "! * "
    which cmake
    echo -n "!   * "
    cmake --version | head -n 1

    # echo -n "! * "
    # which rsync
    # echo -n "!   * "
    # rsync --version | head -n 1
}

TTL () {
    local -i m=$1; shift
    OUTPUT=""
    local SILENT=""
    for arg; do
        shift
        if [[ "$arg" == "---output" ]]; then
            OUTPUT="1"
            continue
        fi
        if [[ "$arg" == "---silent" ]]; then
            SILENT="1"
            continue
        fi
        set -- "$@" "$arg"
    done

    if [[ $SILENT == "" ]]; then
        echo -ne "\n>> "
        echo -n "${@}"
        echo " [TTL=${m}m]"
    fi

    if [[ $OUTPUT == "1" ]]; then
        ("$@" > "$WORK/tmp_ttl.txt") &
    else
        "$@" &
    fi

    local -i pid=$!
    local -i span=0
    local -i s=$((m * 60))

    while kill -0 $pid >/dev/null 2>&1; do
        sleep 1
        ((s++))
        if [ $span -ge $s ]; then
            echo -e "\nERROR: Timeout ${m}m"

            # kill $pid >/dev/null 2>&1

            # kill $pid && break

            # echo "kill gracefully"
            # kill -s SIGTERM $pid && kill -0 $pid || exit 0
            # sleep 1
            # echo "kill brutaly"
            # kill -s SIGKILL $pid
        fi
    done

    if [[ $OUTPUT == "1" ]]; then
        OUTPUT=$(cat "$WORK/tmp_ttl.txt")
        if [[ $SILENT == "" ]]; then
            echo ">> OUTPUT: $OUTPUT"
        fi
    fi
}
