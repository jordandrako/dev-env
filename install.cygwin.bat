@ECHO OFF

goto CHECKPERMISSIONS

:CHECKPERMISSIONS
echo [DEV ENV] Administrative permissions required. Detecting permissions...

net session >nul 2>&1
if %errorLevel% == 0 (
    echo [DEV ENV] Success: Administrative permissions confirmed.
    goto SETENV
) else (
    echo [DEV ENV] Failure: Current permissions inadequate.
    goto ERROR
)

:SETENV
echo [DEV ENV] Setting environment variables
set profile="%HOMEDRIVE%%HOMEPATH%"
set cygwinpath="%HOMEDRIVE%\cygwin64"
set cygwinhome="%cygwinpath%\home\%USERNAME%"
if not exist "%profile%\code" mkdir "%profile%\code"
setx CODE_DIR "%profile%\code"
setx GIT_ROOT "%HOMEDRIVE%\Program Files\Git"

:INSTALL
echo [DEV ENV] Installing
if exist "%cygwinpath%\*.*" goto COPYCONFIGS
echo [DEV ENV] You need to install cygwin separately. https://www.cygwin.com/. Then install wget and install apt-cyg

:COPYCONFIGS
echo [DEV ENV] Copying configs
if exist "%cygwinhome%" (
  xcopy /s/e/h/y home "%cygwinhome%\"
)
if not exist "%HOMEDRIVE%\cmder" (mkdir "%HOMEDRIVE%\cmder" || goto ERROR)
xcopy /s/e/h/y cmder "%HOMEDRIVE%\cmder\"
set /p answer=Do you want to copy .ssh config (Y / N)?
if "%answer:~0,1%"=="Y" GOTO SSH
if "%answer:~0,1%"=="y" GOTO SSH
goto END

:SSH
if exist "%profile%\.ssh" (
  xcopy /s/e/h/y/O "%profile%\.ssh" "%cygwinhome%\.ssh\" || goto ERROR
)
goto END

:ERROR
ECHO [DEV ENV] Terminating due to internal error #%errorlevel%
EXIT /b %errorlevel%

:END
echo [DEV ENV] Done. Run install.bash.sh from bash or zsh.
exit /b