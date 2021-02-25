#!/usr/bin/env bash
## forking is evil
TTL () {
    time=$1; shift
    $@ & local pid=$! start=0
    while true; do
        kill -0 $pid >/dev/null 2>&1
        if [ "$?" == "1" ]; then
            break
        fi
        read -t 1
        start=$((start+1))
        if [ $start -ge $time ]; then
            echo -e "\nERROR: Timeout $time s"
            kill $pid && break
        fi
    done
}

# export -f TTL

TTLa () {
    m=$1; shift
    s=$((m * 60))
    echo ">> $@  [TTL=${m}m]"
    timeout $s $@
    ret=$?
    case $ret in
          0) ;;
        124) echo "ERROR: Time Out ${m}m: $@" ;;
          *) echo "[WARN] Exit code $ret" ;;
    esac
    return $ret
}

TTLb () {
    local arr=( "$@" )
    local timeout="${arr[0]}"
    local cmd=( "${arr[@]:1}" )

    echo "timeout=$timeout"
    echo ">> ${cmd[@]}  [TTL=${timeout}s]"

    (
        eval "${cmd[@]}" &
        pid=$!

        echo "child pid: $pid"
        trap -- "" SIGTERM
        (
            sleep "$timeout"
            kill "$pid" 2> /dev/null
            echo $?
        ) &
        wait "$pid"
    )
}

TTLc () {
    trap -- "" SIGTERM

    local pid=$!
    local t=$1
    # local s=$((m * 60))

    (
        sleep $t
        echo -e "\nERROR: Timeout $t s"
        kill $pid
    ) &
    wait $pid
}

