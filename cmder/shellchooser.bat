@ECHO off

:TOP
CLS
ECHO Choose a shell:
ECHO "[1] WSL"
ECHO "[2] Cygwin ZSH"
ECHO "[3] Cygwin Fish"
ECHO "[4] Cygwin Bash"
ECHO "[5] CMDER options"
ECHO "[6] More options"
ECHO.
ECHO "[7] Restart hyper elevated"
ECHO "[8] Exit"
ECHO.

CHOICE /N /C:12345678 /D 1 /T 10 /M "> "
CLS
IF ERRORLEVEL ==8 GOTO end
IF ERRORLEVEL ==7 powershell -Command "Start-Process hyper -Verb RunAs"
IF ERRORLEVEL ==6 GOTO OTHER
IF ERRORLEVEL ==5 GOTO CMDER
IF ERRORLEVEL ==4 GOTO CYGBASH
IF ERRORLEVEL ==3 GOTO CYGFISH
IF ERRORLEVEL ==2 GOTO CYGZSH
IF ERRORLEVEL ==1 GOTO WSL

:CMDER
CLS
ECHO Choose a shell:
ECHO "[1] CMDER cmd"
ECHO "[2] CMDER PowerShell"
ECHO "[3] <- Go back"
ECHO.
ECHO "[4] Exit"
ECHO.

CHOICE /N /C:1234 /D 1 /T 10 /M "> "
CLS
IF ERRORLEVEL ==4 GOTO END
IF ERRORLEVEL ==3 GOTO TOP
IF ERRORLEVEL ==2 GOTO CMDERPOWERSHELL
IF ERRORLEVEL ==1 GOTO CMDERCMD

:OTHER
CLS
ECHO Choose a shell:
ECHO "[1] cmd"
ECHO "[2] PowerShell"
ECHO "[3] <- Go back"
ECHO.
ECHO "[4] Exit"
ECHO.

CHOICE /N /C:1234 /D 1 /T 10 /M "> "
CLS
IF ERRORLEVEL ==4 GOTO END
IF ERRORLEVEL ==3 GOTO TOP
IF ERRORLEVEL ==2 PowerShell
IF ERRORLEVEL ==1 cmd

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
C:\cygwin64\bin\bash.exe /bin/xhere /bin/bash ~
goto EXIT

:CYGFISH
C:\cygwin64\bin\bash.exe /bin/xhere /bin/fish ~
goto EXIT

:CYGZSH
C:\cygwin64\bin\bash.exe /bin/xhere /bin/zsh ~
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
IF ERRORLEVEL ==2 GOTO END
IF ERRORLEVEL ==1 GOTO TOP

:END