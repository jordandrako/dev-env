@ECHO OFF

:SETENV
echo [DEV ENV] Setting environment variables
set profile="%HOMEDRIVE%%HOMEPATH%"
set babunpath="%profile%\.babun"
set babunhome="%babunpath%\cygwin\home\%USERNAME%"
if not exist "%profile%\code" mkdir "%profile%\code"
setx CODE_DIR "%profile%\code"
setx GIT_ROOT "%HOMEDRIVE%\Program Files\Git"

:INSTALL
echo [DEV ENV] Installing
if exist "%babunpath%\*.*" goto COPYCONFIGS
echo [DEV ENV] You need to install babun separately. http://babun.github.io/

:COPYCONFIGS
echo [DEV ENV] Copying configs
if exist "%babunhome%" (
  xcopy /s/e/h/y home "%babunhome%\"
)
if not exist "%HOMEDRIVE%\cmder" (mkdir "%HOMEDRIVE%\cmder" || goto ERROR)
xcopy /s/e/h/y cmder "%HOMEDRIVE%\cmder\"
goto END

:ERROR
ECHO [DEV ENV] Terminating due to internal error #%errorlevel%
EXIT /b %errorlevel%

:END
echo [DEV ENV] Done.
exit /b