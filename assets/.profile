NPM_PACKAGES="$HOME/.npm-packages"
PATH="$NPM_PACKAGES/bin:$HOME/bin:$HOME/.local/bin:$HOME/local/bin:$PATH"

# Mount and bind hard drives
if [ -f "$HOME/.mount" ]; then
  . "$HOME/.mount"
fi
