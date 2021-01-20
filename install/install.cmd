@echo off

assoc .=shebangfile

pushd ..
ftype shebangfile=%cd%\bin\shebang.cmd "%%1" %%*
popd

setx /m PATHEXT %PATHEXT%;.
setx PATHEXT %PATHEXT%;.
set PATHEXT=%PATHEXT%;.
echo PATHEXT: %PATHEXT%
echo on
