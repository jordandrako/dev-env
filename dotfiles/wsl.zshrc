
## WSL configs
unsetopt BG_NICE
export CODE_DIR=/mnt/c/code
export MACHINE="WSL"
echo -e "Welcome $USER! | Machine: $MACHINE\n"

alias coder="cd $CODE_DIR"

if command -v docker.exe >/dev/null 2>&1; then
  alias docker="docker.exe"
fi
