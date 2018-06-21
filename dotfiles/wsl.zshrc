
## WSL configs
unsetopt BG_NICE
export CODE_DIR=/mnt/c/code
export MACHINE="WSL"
echo -e "Welcome $USER! | Machine: $MACHINE\n"

# Color configuration
# LS_COLOR should contain the LS_COLORS overrides you desire.
# Override "other writable" color
LS_COLOR="ow=01;34"
# Add LS_COLOR to the end of existing LS_COLORS
LS_COLORS="$LS_COLORS:$LS_COLOR"
# Re-export LS_COLORS
export LS_COLORS

alias coder="cd $CODE_DIR"

if command -v docker.exe >/dev/null 2>&1; then
  alias docker="docker.exe"
fi
