@ECHO OFF

:SETENV
echo [DEV ENV] Setting environment variables
set PROFILEPATH "%HOMEDRIVE%%HOMEPATH%"
:: Assign all Path variables
if not exist "%PROFILEPATH%\code" mkdir "%PROFILEPATH%\code"
setx CODE_DIR "%PROFILEPATH%\code"
setx GIT_ROOT "%HOMEDRIVE%\Program Files\Git"

:INSTALL
echo [DEV ENV] Installing
if exist "%PROFILEPATH%\.babun\*.*" goto COPYCONFIGS

:ASK
echo [DEV ENV] You should probably install babun separately first, as continuing can take a long time.
set /p answer=[DEV ENV] Do you want to install anyway (Y / N)?
if /i "%answer:~,1%" EQU "Y" goto CALLBABUN
if /i "%answer:~,1%" EQU "N" goto COPYCONFIGS
goto ASK

:CALLBABUN
call babun\install.bat

:COPYCONFIGS
echo [DEV ENV] Copying configs
if exist "%PROFILEPATH%\.babun\cygwin\home\%USERNAME%\*.*" (
  xcopy /s/e/h/y home "%PROFILEPATH%\.babun\cygwin\home\%USERNAME%\"
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