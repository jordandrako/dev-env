@ECHO OFF

:SETENV
echo [DEV ENV] Setting environment variables
set profile="%HOMEDRIVE%%HOMEPATH%"
set cygwinpath="%HOMEDRIVE%\cygwin64"
set cygwinhome="%cygwinpath%\home\%USERNAME%"
if not exist "%profile%\code" mkdir "%profile%\code"

:INSTALL
echo [DEV ENV] Installing
if exist "%cygwinpath%\*.*" goto COPYCONFIGS
echo [DEV ENV] You need to install cygwin with wget separately. https://www.cygwin.com/.

:COPYCONFIGS
echo [DEV ENV] Copying configs
if exist "%cygwinhome%" (
  xcopy /s/e/h/y home "%cygwinhome%\"
)
if not exist "%HOMEDRIVE%\cmder" (mkdir "%HOMEDRIVE%\cmder" || goto ERROR)
xcopy /s/e/h/y cmder "%HOMEDRIVE%\cmder\"
if exist "%HOMEDRIVE%\cmder\vendor\conemu-maximus5\ConEmu\wsl\cygwin1.dll" (
  del "%HOMEDRIVE%\cmder\vendor\conemu-maximus5\ConEmu\wsl\cygwin1.dll"
)

:ASKSSH
set /p answer=Do you want to copy .ssh config (Y / N)?
if "%answer:~0,1%"=="Y" GOTO SSH
if "%answer:~0,1%"=="y" GOTO SSH
goto ASKAWS

:SSH
if exist "%profile%\.ssh" (
  if not exist "%cygwinhome%\.ssh" mkdir "%cygwinhome%\.ssh"
  xcopy /s/e/h/y/O "%profile%\.ssh" "%cygwinhome%\.ssh\"
)
goto END

:ASKAWS
if not exist "%profile%\.aws" (
  set /p answer=Do you want to copy AWS config (Y / N)?
  if "%answer:~0,1%"=="Y" GOTO AWS
  if "%answer:~0,1%"=="y" GOTO AWS
  goto END
)

:AWS
if exist "%profile%\.aws" (
  if not exist "%cygwinhome%\.aws" mkdir "%cygwinhome%\.aws"
  xcopy /s/e/h/y/O "%profile%\.aws" "%cygwinhome%\.aws\"
)
goto END

:ERROR
ECHO [DEV ENV] Terminating due to internal error #%errorlevel%
EXIT /b %errorlevel%

:END
echo [DEV ENV] Done. Install oh-my-zsh then run install.sh from bash or zsh.
exit /b