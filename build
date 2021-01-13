#!/bin/bash

interpreter=$1
product=$2
sub=$(date +%F_%H-%M-%S)

mkdir -p "_working/$product/$sub" && pushd "$_" || exit
file=$(find "./../../../recipies/$product/" -name "index.*")
$interpreter "$file" | tee main.log
popd
