@echo off
assoc .=shebangfile
ftype shebangfile=%cd%\bin\shebang.cmd "%%1" %%*
setx /m PATHEXT %PATHEXT%;.
setx PATHEXT %PATHEXT%;.
set PATHEXT=%PATHEXT%;.
echo PATHEXT: %PATHEXT%
echo on
