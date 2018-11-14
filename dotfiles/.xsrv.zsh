#!/bin/zsh

# X Server
export LIBGL_ALWAYS_INDIRECT=1
export DISPLAY=0:0
sudo /etc/init.d/dbus start &> /dev/null
