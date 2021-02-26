#!/usr/bin/env bash

EnsureStdFolderTreeAndCdRepo () {
    TEMP="$PWD"
    mkdir -p ../_data && pushd "$_" 1>/dev/null || exit
    mkdir -p git_log 1>/dev/null
    DATA="$PWD"
    popd 1>/dev/null || exit
    mkdir -p ../_repo && cd "$_" 1>/dev/null || exit
    REPO="$PWD"
}

PrintStdFolders () {
    echo "~ DATA:     $DATA"
    echo "~ REPO:     $REPO"
    echo "~ TEMP:     $TEMP"
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
