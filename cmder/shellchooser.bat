@ECHO off

:top
CLS
ECHO Choose a shell:
ECHO [1] WSL
ECHO [2] Cygwin ZSH
ECHO [3] Cygwin Bash
ECHO [4] CMDER cmd
ECHO [5] CMDER PowerShell
ECHO [6] cmd
ECHO [7] Powershell
ECHO.
ECHO [8] restart hyper elevated
ECHO [9] exit
ECHO.

CHOICE /N /C:123456789 /D 1 /T 10 /M "> "
CLS
IF ERRORLEVEL ==9 GOTO end
IF ERRORLEVEL ==8 powershell -Command "Start-Process hyper -Verb RunAs"
IF ERRORLEVEL ==7 powershell
IF ERRORLEVEL ==6 cmd
IF ERRORLEVEL ==5 GOTO CMDERPOWERSHELL
IF ERRORLEVEL ==4 GOTO CMDERCMD
IF ERRORLEVEL ==3 GOTO CYGBASH
IF ERRORLEVEL ==2 GOTO CYGZSH
IF ERRORLEVEL ==1 GOTO WSL

:CMDERPOWERSHELL
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''C:\cmder\vendor\profile.ps1'''"
goto EXIT

:CMDERCMD
SET CMDER_ROOT=C:\cmder
IF EXIST %CMDER_ROOT% (
  cmd /k "%CMDER_ROOT%\vendor\init.bat"
)
goto EXIT

:CYGBASH
C:\cygwin64\bin\bash.exe
goto EXIT

:CYGZSH
C:\cygwin64\bin\bash.exe /bin/xhere /bin/zsh
goto EXIT

:WSL
%windir%\System32\wsl.exe ~

:EXIT
CLS
ECHO Shell exited.
ECHO.
ECHO Switch or exit?
ECHO [1] Switch
ECHO [2] Exit

CHOICE /N /C:12 /D 2 /T 5 /M "> "
IF ERRORLEVEL ==2 GOTO end
IF ERRORLEVEL ==1 GOTO top

:end