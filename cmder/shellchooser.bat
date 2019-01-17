@ECHO off

:TOP
CLS
set shellchoice=Shell
set CYGHOME=/home/%USERNAME%
SET CMDER_ROOT=C:\cmder
ECHO Choose a shell:
ECHO [1]* WSL
ECHO [2]  Cygwin ZSH
ECHO [3]  CMDER cmd
ECHO ---
ECHO [4]  Cygwin Bash
ECHO [5]  CMDER powershell
ECHO [6]  More options
ECHO ---
ECHO [7]  Restart hyper elevated
ECHO [8]  Exit
ECHO (*^)  Default option
ECHO.

CHOICE /N /C:12345678 /D 1 /T 5 /M "> "
CLS
IF ERRORLEVEL ==8 GOTO end
IF ERRORLEVEL ==7 powershell -Command "Start-Process hyper -Verb RunAs"
IF ERRORLEVEL ==6 GOTO OTHER
IF ERRORLEVEL ==5 GOTO CMDERPOWERSHELL
IF ERRORLEVEL ==4 GOTO CYGBASH
IF ERRORLEVEL ==3 GOTO CMDERCMD
IF ERRORLEVEL ==2 GOTO CYGZSH
IF ERRORLEVEL ==1 GOTO LAUNCHWSL

:OTHER
CLS
ECHO Choose a shell (more options^):
ECHO [1]* cmd
ECHO [2]  PowerShell
ECHO [3]  ^<- Go back
ECHO ---
ECHO [4]  Exit
ECHO (*^)  Default option
ECHO.

CHOICE /N /C:1234 /D 1 /T 5 /M "> "
CLS
IF ERRORLEVEL ==4 GOTO END
IF ERRORLEVEL ==3 GOTO TOP
IF ERRORLEVEL ==2 GOTO POWERSHELLVANILLA
IF ERRORLEVEL ==1 GOTO CMDVANILLA

:POWERSHELLVANILLA
set shellchoice=PowerShell
powershell
goto EXIT

:CMDVANILLA
set shellchoice=cmd
cmd
goto EXIT

:CMDERPOWERSHELL
set shellchoice=CMDER PowerShell
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''C:\cmder\vendor\profile.ps1'''"
goto EXIT

:CYGBASH
set HOME=%CYGHOME%
set shellchoice=Cygwin Bash
C:\cygwin64\bin\bash.exe /bin/xhere /bin/bash
goto EXIT

:CMDERCMD
set shellchoice=CMDER cmd
IF EXIST %CMDER_ROOT% (
  cmd /k "%CMDER_ROOT%\vendor\init.bat"
)
goto EXIT

:CYGZSH
set HOME=%CYGHOME%
set shellchoice=Cygwin ZSH
C:\cygwin64\bin\bash.exe /bin/xhere /bin/zsh
goto EXIT

:LAUNCHWSL
set shellchoice=WSL
wsl

:EXIT
CLS
ECHO %shellchoice% exited.
ECHO.
ECHO Switch or exit?
ECHO [1] Switch
ECHO [2] Exit

CHOICE /N /C:12 /D 2 /T 5 /M "> "
IF ERRORLEVEL ==2 GOTO END
IF ERRORLEVEL ==1 GOTO TOP

:END
EXIT 0
