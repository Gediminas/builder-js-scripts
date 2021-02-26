#!/usr/bin/env bash

TTL () {
    local -i lifespan=$1; shift
    $@ &
    local pid=$!
    local elapsed=0
    while kill -0 $pid >/dev/null 2>&1; do
        sleep 1
        ((elapsed++))
        if [ $elapsed -ge $lifespan ]; then
            echo -e "\nERROR: Timeout ${lifespan}s"

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
