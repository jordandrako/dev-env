#!/bin/zsh

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# Source common functions: green, info, error, try, ask.
[[ -s ~/.functions.sh ]] && source ~/.functions.sh

# Utility
alias -g and="&&"
alias -g or="||"
alias uefi="sudo systemctl reboot --firmware-setup"
alias eufi="sudo systemctl reboot --firmware-setup"
alias pid="info 'Click on the window to find its PID' && xprop _NET_WM_PID | cut -d' ' -f3"
alias killwindow="info 'Click on the window to kill it' && xprop _NET_WM_PID | cut -d' ' -f3 | xargs kill"
alias untar="tar xzvf"
function untard() {
  dir=`echo $1 | sed 's/\.tar\.gz//gI'`
	mkdir -p "./$dir"
	tar xzvf $1 -C "./$dir"
}
alias targzip="tar czvf"

# Directory navigation
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

if [[ -x `command -v trash` ]]; then
  alias yeet="trash"
else
  alias yeet="rm -rf"
fi

# List large directories
alias ducks="du -cksh * | sort -rh | head"

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

# Cmder
if [[ -x `command -v cmd.exe` ]]; then
  alias cmder="cmd.exe /k 'C:\\cmder\\integratedterm.bat'"
fi

# Git
if [[ -x `command -v git` ]]; then
  alias gs="git status -s"
  alias gss="git status"
  alias gl="git lg"
  alias gf="git fetch"
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

  # Git finish. USAGE: gfin "Commit message" [remote-branch]
  gfin() {
    if [[ `git status -s | wc -l` -lt 1 ]]; then
      echo "No changes."
    elif [[ ! $1 ]]; then
      echo "You must specify a commit message! USAGE: gfin \"Commit message\" [remote-branch]"
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
    wipBranch="${originalBranch}--WIP_${date}"

    if [[ `git status -s | wc -l` -lt 1 ]]; then
      echo "No changes."
    else
      # If wipBranch exists already, delete it before making new WIP branch.
      if [[ `git branch --list $wipBranch | wc -l` -gt 0 ]]; then
        git del $wipBranch
      fi

      git checkout -b $wipBranch
      git add -A && git commit -m "WIP_${date}_${time}" --no-verify
      [[ $isLocal != true ]] && git push --force -u origin $wipBranch
      git checkout $originalBranch
      git merge --squash --no-commit $wipBranch
      git unstage
      [[ $isLocal != true ]] && git del $wipBranch
    fi
  }

  # Deletes local branches that don't exist on origin remote with confirmation.
  git-prune-local() {
    while true; do
      git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}'
      git fetch -p --dry-run
      ask "Remove these local branches?" "y/N" pruneYn
      case $pruneYn in
        [yY]* )
          git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D;
          git fetch -p;
          break;;
        * )
          info "Branches not removed.";
          break;;
      esac
    done
  }
fi

# NPM
if [[ -x `command -v npm` ]]; then
  alias ns="npm start"
  alias ni="npm i"
  alias nid="npm i -D"
  alias ngi="npm i -g"
  alias nrm="npm rm"
  alias nrmg="npm rm -g"

fi

# Yarn
if [[ -x `command -v yarn` ]]; then
  alias ys="yarn start"
  alias ya="yarn add"
  alias yad="yarn add -D"
  alias yrm="yarn remove"
  alias yaw="yarn add -W"
  alias yawd="yarn add -DW"
  alias yadw="yarn add -DW"
fi

# Docker
if [[ -x `command -v docker` ]]; then
  alias dl="docker logs"
  alias dlf="docker logs -f"
  alias dps="docker ps"
  alias dpsa="docker ps -a"
  alias dr="docker restart"
  alias drestart="docker restart"
  alias dra="docker restart $(docker ps -a -q)"
  alias drestartall="docker restart $(docker ps -a -q)"
  alias dcu="docker compose up"
  alias dcupdb="docker compose up -d --build --remove-orphans"
  alias dcp="docker compose pull"
  alias dcupdate="docker compose pull && docker compose up -d --build --remove-orphans --force-recreate"
  alias dcd="docker compose down"
  alias dcl="docker compose logs"

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

# Apt
if [[ -x `command -v apt` || -x `command -v apt-get` ]]; then
  alias apt-upgrade="sudo apt update && sudo apt -y upgrade"
  alias apt-install="sudo apt install"
fi

# WSL Powershell
if [[ -x `command -v powershell.exe` ]]; then
  alias shutdown="powershell.exe wsl --shutdown"
fi

# WSL ADB
if [[ -x `command -v adb.exe` ]]; then
  alias adb="adb.exe"
fi

# IdeaIU
if [[ -f ~/ideaIU/bin/idea.sh ]]; then
  alias idea="~/ideaIU/bin/idea.sh &!"
fi
