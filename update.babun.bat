@ECHO OFF

set profile="%HOMEDRIVE%%HOMEPATH%"
set babunpath="%profile%\.babun"
set babunhome="%babunpath%\cygwin\home\%USERNAME%"

if exist "%babunhome%" (
  xcopy /s/e/h/y home "%babunhome%\"
)
if exist "%HOMEDRIVE%\cmder" (
  xcopy /s/e/h/y cmder "%HOMEDRIVE%\cmder\"
)
