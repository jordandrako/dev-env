#!/bin/zsh

dl_path="https://raw.githubusercontent.com/jordandrako/dev-env/master/dotfiles"

# Global configuration
wget "${dl_path}/.zshrc" -o ~/.zshrc

wget "${dl_path}/.nanorc" -o ~/.nanorc

wget "${dl_path}/.tmux.conf" -o ~/.tmux.conf

wget "${dl_path}/.p10k.zsh" -o ~/.p10k.zsh

wget "${dl_path}/.key-bindings.zsh" -o ~/.config/.key-bindings.zsh

wget "${dl_path}/.functions.zsh" -o ~/.config/.functions.zsh

wget "${dl_path}/.aliases.zsh" -o ~/.config/.aliases.zsh

wget "${dl_path}/.linux.zsh" -o ~/.config/.linux.zsh

# fzf plugin
if [[ ! -f ~/.fzf.zsh ]]; then
  [[ -d ~/.fzf ]] && rm -rf ~/.fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --no-bash --no-fish --no-update-rc --key-bindings --completion
fi
