@ECHO off

:top
CLS
ECHO Choose a shell:
ECHO [1] WSL
ECHO [2] ZSH
ECHO [3] CMDER cmd
ECHO [4] CMDER PowerShell
ECHO [5] cmd
ECHO [6] Powershell
ECHO.
ECHO [8] restart hyper elevated
ECHO [9] exit
ECHO.

CHOICE /N /C:12345689 /D 1 /T 10 /M "> "
CLS
IF ERRORLEVEL ==9 GOTO end
IF ERRORLEVEL ==8 powershell -Command "Start-Process hyper -Verb RunAs"
IF ERRORLEVEL ==6 powershell
IF ERRORLEVEL ==5 cmd
IF ERRORLEVEL ==4 GOTO CMDERPOWERSHELL
IF ERRORLEVEL ==3 GOTO CMDERCMD
IF ERRORLEVEL ==2 GOTO CYGZSH
IF ERRORLEVEL ==1 GOTO WSL

:CMDERPOWERSHELL
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''C:\cmder\vendor\profile.ps1'''"
goto FALLBACK

:CMDERCMD
SET CMDER_ROOT=C:\cmder
IF EXIST %CMDER_ROOT% (
  cmd /k "%CMDER_ROOT%\vendor\init.bat"
)
goto FALLBACK

:CYGZSH
C:\cygwin64\bin\bash.exe /bin/xhere /bin/zsh
goto FALLBACK

:FALLBACK
ECHO Something went wrong, falling back to WSL.
ECHO.
goto WSL

:WSL
%windir%\System32\wsl.exe ~

CLS
ECHO You choice didn't work.
ECHO.
ECHO Switch or exit?
ECHO [1] Switch
ECHO [2] Exit

CHOICE /N /C:12 /D 2 /T 5 /M "> "
IF ERRORLEVEL ==2 GOTO end
IF ERRORLEVEL ==1 GOTO top

:end