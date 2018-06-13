switch (uname -a)
  case '*Microsoft*'
    set machine 'WSL'
    set CODE_DIR '/mnt/c/code'
  case 'Linux*'
    set machine 'Linux'
    set CODE_DIR '~/code'
  case '*'
    set machine 'UNKNOWN'
end

set N_PREFIX $HOME/n
function read_n
  while true
    read -l -P "Add N to path? [y/N] " nYn
    switch $nYn
      case Y y
        set -U fish_user_paths $N_PREFIX/bin $fish_user_paths
        return 1
      case '*'
        return 0
    end
    echo -e '\n'
  end
end
if test -x $N_PREFIX/bin/n
  read_n
end

function read_omf
  while true
    read -l -P "Install oh my fish [y/N] " ohmyfishYn
    switch $ohmyfishYn
      case Y y
        curl -L https://get.oh-my.fish | fish
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
    read -l -P "Install oh my fish theme? [Y/n] " themeYn
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
    read -l -P "Install fisherman [y/N] " fishermanYn
    switch $fishermanYn
      case Y y
        curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
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
    read -l -P "Install fisher plugins [Y/n] " pluginsYn
    switch $pluginsYn
      case '' Y y
        fisher z edc/bass
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
  cd $CODE_DIR
end
funcsave coder

function dockera
  if $machine == 'WSL'
    docker.exe $argv
  else
    docker $argv
  end
end
funcsave dockera

if type -q set_aliases
  set_aliases
end