# WSL specific ZSH settings
unsetopt BG_NICE
export CODE_DIR=/mnt/c/code
export MACHINE="WSL"

alias coder="cd $CODE_DIR"
if command -v docker.exe >/dev/null 2>&1; then
  alias docker="docker.exe"
fi
