#!/bin/zsh

## WSL configs
unsetopt BG_NICE
export MACHINE="WSL"
[[ -d /c/code ]] && export CODE_DIR=/c/code || export CODE_DIR=/mnt/c/code

alias coder="cd $CODE_DIR"
alias nsfi="cd $CODE_DIR && cd ui-fabric-website-internal/apps/fabric-website-internal && npm start"

if [[ -x "$(command -v cmd.exe)" ]]; then
  alias cmd="cmd.exe"
  alias x410="cmd.exe /c 'start x410.exe'"
  alias xkill="cmd.exe /c 'taskkill /IM x410.exe'"
  alias xdesktop="cmd.exe /c 'taskkill /IM x410.exe' && cmd.exe /c 'start x410 /desktop'"
fi

if [[ -x "$(command -v docker.exe)" && ! -x "$(command -v docker)" ]]; then
  alias docker="docker.exe"
fi

[[ -x "$(command -v lsb_release)" ]] && [[ `lsb_release -sd | wc -l` -gt 0 ]] && OS="| OS: `lsb_release -sd`"
echo -e "Welcome $USER! | Machine: $MACHINE $OS\n"

[[ -s ~/.xsrv.zsh ]] && source ~/.xsrv.zsh
