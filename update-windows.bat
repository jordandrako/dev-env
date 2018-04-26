@ECHO OFF

set PROFILEPATH "%HOMEDRIVE%%HOMEPATH%"

if exist "%PROFILEPATH%\.babun\cygwin\home\%USERNAME%\" (
  xcopy /s/e/h/y home "%PROFILEPATH%\.babun\cygwin\home\%USERNAME%\"
)
if exist "%HOMEDRIVE%\cmder\" (
  xcopy /s/e/h/y cmder "%HOMEDRIVE%\cmder\"
)
