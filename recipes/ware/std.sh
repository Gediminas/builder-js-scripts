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
    php --version | head -n 1
    echo -n "! * "
    cmake --version | head -n 1
}

TTL () {
    local -i m=$1; shift

    echo ">> $@ [TTL=${m}m]"
    $@ &

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
}

TTX () {
    local -i m=$1; shift
    $@ &
    local -i pid=$!
    local -i span=0
    local -i s=$((m * 60))

    while kill -0 $pid >/dev/null 2>&1; do
        sleep 1
        ((s++))
        if [ $span -ge $s ]; then
            echo -e "\nERROR: Timeout ${m}m"
        fi
    done
}

# export -f TTL

# TTLa () {
#     m=$1; shift
#     s=$((m * 60))
#     echo ">> $@  [TTL=${m}m]"
#     timeout $s $@
#     ret=$?
#     case $ret in
#           0) ;;
#         124) echo "ERROR: Time Out ${m}m: $@" ;;
#           *) echo "[WARN] Exit code $ret" ;;
#     esac
#     return $ret
# }

# TTLb () {
#     local arr=( "$@" )
#     local timeout="${arr[0]}"
#     local cmd=( "${arr[@]:1}" )

#     echo "timeout=$timeout"
#     echo ">> ${cmd[@]}  [TTL=${timeout}s]"

#     (
#         eval "${cmd[@]}" &
#         pid=$!

#         echo "child pid: $pid"
#         trap -- "" SIGTERM
#         (
#             sleep "$timeout"
#             kill "$pid" 2> /dev/null
#             echo $?
#         ) &
#         wait "$pid"
#     )
# }

# TTLc () {
#     trap -- "" SIGTERM

#     local pid=$!
#     local t=$1
#     # local s=$((m * 60))

#     (
#         sleep $t
#         echo -e "\nERROR: Timeout $t s"
#         kill $pid
#     ) &
#     wait $pid
# }
