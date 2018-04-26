@ECHO OFF

set PROFILEPATH "%HOMEDRIVE%%HOMEPATH%\.babun\cygwin\home\%USERNAME%"

REM if exist "%HOMEDRIVE%%HOMEPATH%" (
  xcopy /s/e/h/y home "%PROFILEPATH%\"
REM )
if exist "%HOMEDRIVE%\cmder" (
  xcopy /s/e/h/y cmder "%HOMEDRIVE%\cmder\"
)
