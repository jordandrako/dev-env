@echo off

REM Kill x410 if it's running
tasklist /fi "imagename eq x410.exe" | find ":" > nul
if errorlevel 1 taskkill /f /im "x410.exe"

REM start x410 in windowed mode
start /B x410.exe /wm

REM start xfce panel
wlinux.exe run "if [ -z $(pidof xfce4-panel) ]; then export DISPLAY=127.0.0.1:0.0; cd ~; xfsettingsd --sm-client-disable; xfce4-panel --sm-client-disable --disable-wm-check; taskkill.exe /IM x410.exe; fi;"
