unsetopt PROMPT_SP
export CODE_DIR=/cygdrive/c/code
export MACHINE="Cygwin"

# Color configuration
# LS_COLOR should contain the LS_COLORS overrides you desire.
# Override "other writable" color
LS_COLOR="ow=01;34"
# Add LS_COLOR to the end of existing LS_COLORS
LS_COLORS="$LS_COLORS:$LS_COLOR"
# Re-export LS_COLORS
export LS_COLORS

alias coder="cd $CODE_DIR"
