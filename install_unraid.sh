#!/bin/zsh

dl_path="https://raw.githubusercontent.com/jordandrako/dev-env/master/dotfiles"

# Global configuration
wget "${dl_path}/.zshrc" ~/

wget "${dl_path}/.nanorc" ~/

wget "${dl_path}/.tmux.conf" ~/

wget "${dl_path}/.p10k.zsh" ~/

wget "${dl_path}/.key-bindings.zsh" ~/.config/

wget "${dl_path}/.functions.zsh" ~/.config/

wget "${dl_path}/.aliases.zsh" ~/.config/

wget "${dl_path}/.functions.zsh" ~/.config/

wget "${dl_path}/.linux.zsh" ~/.config/

# fzf plugin
if [[ ! -f ~/.fzf.zsh ]]; then
  [[ -d ~/.fzf ]] && rm -rf ~/.fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --no-bash --no-fish --no-update-rc --key-bindings --completion
fi
