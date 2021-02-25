#!/usr/bin/env sh

# set -e  # exit when any command fails

git_get() {
    repo=$1
    dir=$2
    branch=$3
    shift  # remove $1 from $@
    shift  # remove $2 from $@
    shift  # remove $3 from $@


    echo "## GIT GET MAIN REPO / $repo / $branch"

    git_check_path="$dir/.git/refs/heads"
    if [ -e "$git_check_path" ]; then
        echo ">> git checkout -- ."
        git checkout -- .

        echo ">> git fetch --all --verbose --progress"
        git fetch --all --verbose --progress

        echo ">> git reset --hard "origin/${branch}" --verbose --progress"
        git reset --hard "origin/${branch}"

        echo ">> git clean -fdx"
        git clean -fdx

        echo ">> git pull --verbose --progress"
        git pull --verbose --progress
    else
        echo ">> git clone "$repo" "$dir" -b "$branch" $@"
        git clone "$repo" "$dir" -b "$branch" $@
    fi


    # echo "## GIT GET \"SUBMODULES\""
    # sh ./get_submodules.sh --clean --quiet "$@"
}

export -f git_get
