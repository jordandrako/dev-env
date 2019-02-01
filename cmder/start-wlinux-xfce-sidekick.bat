@echo off

REM ### Start X410 in Windowed Apps Mode. If X410 is already running in Desktop Mode,
REM ### it'll be terminated first without any warning message box.

start /B x410.exe /wm

REM ### Setup a D-Bus instance that will be shared by all X-Window apps

wlinux.exe run "sh -ic 'if [ -z \"$(pidof dbus-launch)\" ]; then export DISPLAY=127.0.0.1:0.0; dbus-launch --exit-with-x11; fi;'"

REM start xfce panel
wlinux.exe run "if [ -z $(pidof xfce4-panel) ]; then export DISPLAY=127.0.0.1:0.0; cd ~; xfsettingsd --sm-client-disable; xfce4-panel --sm-client-disable --disable-wm-check; taskkill.exe /IM x410.exe; fi;"
