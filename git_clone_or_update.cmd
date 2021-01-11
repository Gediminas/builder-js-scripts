@echo off

set folder=%DATE%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
echo %folder%

mkdir _working
mkdir _working\git_clone_or_update
mkdir _working\git_clone_or_update\%folder%

pushd _working\git_clone_or_update\%folder%
node ..\..\..\recipies\git_clone_or_update\index.js 2>&1 | tee main.log
popd

echo on
