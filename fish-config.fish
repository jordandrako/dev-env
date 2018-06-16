#!/usr/bin/fish

function fancy_echo
  echo -e "\n\e[1;30;42m $argv \e[0m\n"
end

switch (uname -a)
  case '*Microsoft*'
    set -Ux MACHINE 'WSL'
    set -Ux CODE_DIR '/mnt/c/code'
  case 'Linux*'
    set -Ux MACHINE 'Linux'
    set -Ux CODE_DIR '~/code'
  case '*'
    set -Ux MACHINE 'UNKNOWN'
end

function read_omf
  while true
    read -l -P "Install oh my fish [y/N] > " ohmyfishYn
    switch $ohmyfishYn
      case Y y
        fancy_echo "This will launch fish for you when complete. \n To continue the install script type 'exit' once fish is running."
        curl -L https://get.oh-my.fish | fish
        fancy_echo "Rerun this script to omf theme."
        return 1
      case '*'
        return 0
    end
    echo -e '\n'
  end
end
if not type -q omf
  read_omf
end

function read_theme
  while true
    read -l -P "Install oh my fish theme? [Y/n] > " themeYn
    switch $themeYn
      case '' Y y
        omf install agnoster
        omf theme agnoster
        return 1
      case '*'
        return 0
    end
    echo -e '\n'
  end
end
if type -q omf
  read_theme
end

function read_fisherman
  while true
    read -l -P "Install fisherman [y/N] > " fishermanYn
    switch $fishermanYn
      case Y y
        curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
        fancy_echo "Rerun this script to install plugins."
        return 1
      case '*'
        return 0
    end
    echo -e '\n'
  end
end
if not type -q fisher
  read_fisherman
end

function read_plugins
  while true
    read -l -P "Install fisherman plugins? [Y/n] > " pluginsYn
    switch $pluginsYn
      case '' Y y
        fisher z edc/bass fnm
        return 1
      case '*'
        return 0
    end
    echo -e '\n'
  end
end
if type -q fisher
  read_plugins
end

function coder
  cd "$CODE_DIR"
end
funcsave coder

function dockera
  if $MACHINE == 'WSL'
    docker.exe $argv
  else
    docker $argv
  end
end
funcsave dockera

mkdir -p ~/.config/fish/functions
cp dotfiles/set_aliases.fish ~/.config/fish/functions/
if type -q set_aliases
  set_aliases
end

# Colors for windows directories
switch $LS_COLORS
  case '*ow=01;34*'
    set -Ux LS_COLORS "$LS_COLORS"
  case '*'
    set -Ux LS_COLORS "$LS_COLORS:ow=01;34"
end

fancy_echo "Done installing fish!"
