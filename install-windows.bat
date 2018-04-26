@ECHO OFF

:SETENV
echo [DEV ENV] Setting environment variables
set profile "%HOMEDRIVE%\%HOMEPATH%"
:: Assign all Path variables
if not exist "%profile%\code" mkdir "%profile%\code"
setx CODE_DIR "%profile%\code"
setx GIT_ROOT "%HOMEDRIVE%\Program Files\Git"

:INSTALL
echo [DEV ENV] Installing
if exist "%profile%\.babun\*.*" goto COPYCONFIGS

echo [DEV ENV] You need to install babun separately.

:COPYCONFIGS
echo [DEV ENV] Copying configs
if exist "%profile%\.babun\cygwin\home\%USERNAME%\*.*" (
  xcopy /s/e/h/y home "%profile%\.babun\cygwin\home\%USERNAME%\"
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