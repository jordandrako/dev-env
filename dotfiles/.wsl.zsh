#!/bin/zsh

## WSL configs
unsetopt BG_NICE
export MACHINE="WSL"
[[ -d ~/code ]] && export CODE_DIR=~/code

alias coder="cd $CODE_DIR"

if [[ -x "$(command -v cmd.exe)" ]]; then
  alias cmd="cmd.exe"
  alias x410="cmd.exe /c 'start x410.exe'"
  alias xkill="cmd.exe /c 'taskkill /IM x410.exe'"
  alias xdesktop="cmd.exe /c 'taskkill /IM x410.exe' && cmd.exe /c 'start x410 /desktop'"
fi

# if [[ -x "$(command -v docker.exe)" && ! -x "$(command -v docker)" ]]; then
#   alias docker="docker.exe"
# fi

# [[ -s ~/.xsrv.zsh ]] && source ~/.xsrv.zsh

# if [[ -d $HOME/.rbenv/bin ]]; then
#   export PATH="$HOME/.rbenv/bin:$PATH"
#   eval "$(rbenv init -)"
#   export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
# fi

# Check if we have and remove Windows NPM from path
# WIN_NPM_PATH="$(dirname "$(which npm)")"
# if [[ "${WIN_NPM_PATH}" == "${WIN_C_PATH}"* ]]; then
#   export PATH=$(echo "${PATH}" | sed -e "s#${WIN_NPM_PATH}/:##")
# fi

# WIN_YARN_PATH="$(dirname "$(which yarn)")"
# if [[ "${WIN_YARN_PATH}" == "${WIN_C_PATH}"* ]]; then
#   export PATH=$(echo "${PATH}" | sed -e "s#${WIN_YARN_PATH}/:##")
# fi
