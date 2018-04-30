@ECHO OFF

set profile="%HOMEDRIVE%%HOMEPATH%"
set cygwinpath="%HOMEDRIVE%\cygwin64"
set cygwinhome="%cygwinpath%\home\%USERNAME%"

if exist "%cygwinpath%" (
  xcopy /s/e/h/y home "%cygwinpath%\"
)
if exist "%HOMEDRIVE%\cmder" (
  xcopy /s/e/h/y cmder "%HOMEDRIVE%\cmder\"
)
