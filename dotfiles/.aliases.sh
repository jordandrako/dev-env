#!/bin/zsh

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../.."
alias -g ......="../../../../.."

alias -- -="cd -"
alias 1="cd -"
alias 2="cd -2"
alias 3="cd -3"
alias 4="cd -4"
alias 5="cd -5"
alias 6="cd -6"
alias 7="cd -7"
alias 8="cd -8"
alias 9="cd -9"

alias md="mkdir -p"
alias rd=rmdir
alias d="dirs -v | head -10"

# List directory contents
if [[ -x `command -v colorls` ]]; then
  source $(dirname $(gem which colorls))/tab_complete.sh
  alias lc="colorls -lA --sd --gs"
  alias ls="colorls"
  alias lsa="colorls -la"
  alias l="colorls -la --sd --gs"
  alias ll="colorls -l --sd --gs"
  alias la="colorls -lA --sd --gs"
else
  alias ls="ls --color=always"
  alias lsa="ls -lah"
  alias l="ls -lah"
  alias ll="ls -lh"
  alias la="ls -lAh"
fi

# Git
if [[ -x `command -v git` ]]; then
  alias gs="git status -s"
  alias gss="git status"
  alias gl="git lg"
  alias ga="git add"
  alias gaa="git add -A"
  alias gac="git add -A && git commit -m"
  alias gc="git commit -m"
  alias go="git checkout"
  alias gob="git checkout -b"
  alias gol="git checkout -"
  alias gm="git merge"
  alias gml="git merge -"
  alias gp="git push"
  alias gpl="git pull"
  alias gd="git diff"
  alias gdc="git diff --cached"
  alias git-NUKE="git reset --hard HEAD && git clean -fdq"

  # Git finish. USAGE: gf "Commit message" [remote-branch]
  gf() {
    if [[ `git status -s | wc -l` -lt 1 ]]; then
      echo "No changes."
    elif [[ ! $1 ]]; then
      echo "You must specify a commit message! USAGE: gf \"Commit message\" [remote-branch]"
    elif [[ $2 && `git ls-remote --heads origin $2 | wc -l` == 0 ]]; then
      echo "Branch \"$2\" does not exist on remote origin."
    else
      git add -A && git commit -m "$1" && [[ $2 ]] && git push origin $2
    fi
  }

  # Git WIP (Work-In-Progress). USAGE: gwip [-l (--local: don't push)]
  # WARNING: WIP branches are not a replacement for stash!
  # They are deleted if '--local' is NOT used OR it is ran again the same day.
  gwip() {
    date=`date +%Y-%m-%d`
    time=`date +%H:%M:%S`
    originalBranch=`git symbolic-ref --short -q HEAD` || "(unnamed branch)"
    if [[ $1 && $1 == '-l' || $1 && $1 == '--local' ]]; then
      isLocal=true
    fi
    wipBranch="$originalBranch--WIP_$date"

    if [[ `git status -s | wc -l` -lt 1 ]]; then
      echo "No changes."
    else
      # If wipBranch exists already, delete it before making new WIP branch.
      if [[ `git branch --list $wipBranch | wc -l` -gt 0 ]]; then
        git del $wipBranch
      fi

      git checkout -b $wipBranch
      git add -A && git commit -m "$WIP_$date-$time" --no-verify
      [[ $isLocal != true ]] && git push --force -u origin $wipBranch
      git checkout $originalBranch
      git merge --squash --no-commit $wipBranch
      git unstage
      [[ $isLocal != true ]] && git del $wipBranch
    fi
  }
else
  echo "Install git ya git!"
fi

# NPM
if [[ -x `command -v npm` ]]; then
  alias ns="npm start"
  alias ni="npm i"
  alias nid="npm i -D"
  alias ngi="npm i -g"
  alias nrm="npm rm"
  alias nrmg="npm rm -g"

  # Yarn
  if [[ -x `command -v yarn` ]]; then
    alias ys="yarn start"
    alias ya="yarn add"
    alias yad="yarn add -D"
    alias yrm="yarn remove"
  fi

  # Create react app
  if [[ -x `command -v create-react-app` ]]; then
    alias cra="create-react-app"
    crats() {
      create-react-app $1 --typescript
    }
  elif [[ -x `command -v npx` ]]; then
    alias cra="npx create-react-app"
    crats() {
      npx create-react-app $1 --typescript
    }
  fi
fi

# Docker
if [[ -x `command -v docker` ]]; then
  docker_i=true
  alias dl="docker logs"
  alias dps="docker ps"
  alias dpsa="docker ps -a"
  alias dr="docker restart"
  alias drestart="docker restart"
  alias dra="docker restart $(docker ps -a -q)"
  alias drestartall="docker restart $(docker ps -a -q)"
  alias dcu="docker-compose up"
  alias dcd="docker-compose down"

  # Check if container is running. Returns true or false.
  # USAGE: disup container-name && <command if true> || <command if false>
  disup() {
    [[ `docker ps -q -f name=$1` && ! `docker ps -aq -f status=exited -f name=$1` ]] && true || false
  }
fi

# Ngrok
if [[ -x `command -v ngrok` ]]; then
  alias ngr="ngrok http --host-header=rewrite"
fi

# hassio
if [[ -x `command -v hassio` ]]; then
  alias conf="cd /config"
  alias ha="hassio ha"
  alias logs="hassio ha logs"
  restart() {
    echo "Running config check..."
    hassio ha check && \
    echo "Config check passed. Restarting..." && \
    hassio ha restart $*
  }
fi

# Hass (docker)
if [[ docker_i && `docker ps -q -f name=hass` && ! `docker ps -aq -f status=exited -f name=hass` ]]; then
  alias hass_conf="cd ~/.config/docker-configs/hass"
  alias hass_check="docker exec -it hass python -m homeassistant -c /config --script check_config"
  alias hass_logs="docker logs hass"

  hass_restart() {
    echo "Running config check..."
    hass_check && \
    echo "Config check passed. Restarting..." && \
    docker restart hass
  }
fi

# Rush
if [[ -x `command -v rush` ]]; then
  alias rb="rush build"
  alias rrb="rush rebuild"
  alias rbt="rush build -t"
  alias rbtf="rush build -t office-ui-fabric-react"
  alias rbti="rush build -t fabric-website-internal"
fi
