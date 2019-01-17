REM Kill x410 if it's running
tasklist /fi "imagename eq x410.exe" | find ":" > nul
if errorlevel 1 taskkill /f /im "x410.exe"

REM Start x410 in desktop mode
start /B x410.exe /desktop

REM Run wsl xfce4 session
wsl.exe run "if [ -z \"$(pidof xfce4-session)\" ]; then export DISPLAY=127.0.0.1:0.0; xfce4-session; pkill '(gpg|ssh)-agent'; fi;"
