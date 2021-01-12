#!/bin/bash

product=$1
sub=$(date +%F_%H-%M-%S)

mkdir -p "_working/$product/$sub" && pushd "$_" || exit
node "../../../recipies/$product/index.js" | tee main.log
popd
