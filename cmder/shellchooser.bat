@ECHO off

:TOP
CLS
set shellchoice=Shell
ECHO Choose a shell:
ECHO [1]  WSL
ECHO [2]  Cygwin ZSH
ECHO [3]* CMDER cmd
ECHO ---
ECHO [4]  Cygwin Fish
ECHO [5]  Cygwin Bash
ECHO [6]  CMDER powershell
ECHO [7]  More options
ECHO ---
ECHO [8]  Restart hyper elevated
ECHO [9]  Exit
ECHO (*^)  Default option
ECHO.

CHOICE /N /C:123456789 /D 3 /T 10 /M "> "
CLS
IF ERRORLEVEL ==9 GOTO end
IF ERRORLEVEL ==8 powershell -Command "Start-Process hyper -Verb RunAs"
IF ERRORLEVEL ==7 GOTO OTHER
IF ERRORLEVEL ==6 GOTO CMDERPOWERSHELL
IF ERRORLEVEL ==5 GOTO CYGBASH
IF ERRORLEVEL ==4 GOTO CYGFISH
IF ERRORLEVEL ==3 GOTO CMDERCMD
IF ERRORLEVEL ==2 GOTO CYGZSH
IF ERRORLEVEL ==1 GOTO WSL

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

CHOICE /N /C:1234 /D 1 /T 10 /M "> "
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
set shellchoice=Cygwin Bash
C:\cygwin64\bin\bash.exe /bin/xhere /bin/bash ~
goto EXIT

:CYGFISH
set shellchoice=Cygwin Fish
C:\cygwin64\bin\bash.exe /bin/xhere /bin/fish ~
goto EXIT

:CMDERCMD
set shellchoice=CMDER cmd
SET CMDER_ROOT=C:\cmder
IF EXIST %CMDER_ROOT% (
  cmd /k "%CMDER_ROOT%\vendor\init.bat"
)
goto EXIT

:CYGZSH
set shellchoice=Cygwin ZSH
C:\cygwin64\bin\bash.exe /bin/xhere /bin/zsh ~
goto EXIT

:WSL
set shellchoice=WSL
%windir%\System32\wsl.exe ~

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
