
## Cygwin configs
unsetopt PROMPT_SP
export CODE_DIR=/cygdrive/c/code
export MACHINE="Cygwin"
echo -e "Welcome $USER! | Machine: $MACHINE | Shell: $SHELL\n"

# Nodist
nodist_dir="/cygdrive/c/Program Files (x86)/Nodist"
[[ -a "$nodist_dir/bin/nodist_bash_profile_content.sh" ]] && source "$nodist_dir/bin/nodist_bash_profile_content.sh"

# Color configuration
# LS_COLOR should contain the LS_COLORS overrides you desire.
# Override "other writable" color
LS_COLOR="ow=01;34"
# Add LS_COLOR to the end of existing LS_COLORS
LS_COLORS="$LS_COLORS:$LS_COLOR"
# Re-export LS_COLORS
export LS_COLORS

alias coder="cd $CODE_DIR"
