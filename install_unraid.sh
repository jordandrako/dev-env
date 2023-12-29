#!/bin/zsh

dl_path="https://raw.githubusercontent.com/jordandrako/dev-env/master/dotfiles"

# Global configuration
wget "${dl_path}/.zshrc" -O ~/.zshrc

wget "${dl_path}/.nanorc" -O ~/.nanorc

wget "${dl_path}/.tmux.conf" -O ~/.tmux.conf

wget "${dl_path}/.p10k.zsh" -O ~/.p10k.zsh

wget "${dl_path}/.key-bindings.zsh" -O ~/.config/.key-bindings.zsh

wget "${dl_path}/.functions.zsh" -O ~/.config/.functions.zsh

wget "${dl_path}/.aliases.zsh" -O ~/.config/.aliases.zsh

wget "${dl_path}/.linux.zsh" -O ~/.config/.linux.zsh

# fzf plugin
if [[ ! -f ~/.fzf.zsh ]]; then
  [[ -d ~/.fzf ]] && rm -rf ~/.fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --no-bash --no-fish --no-update-rc --key-bindings --completion
fi
