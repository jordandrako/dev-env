#!/bin/bash

export N_PREFIX="$HOME/.bin/n"

temp_path="$PATH"

# Temporarily remove windows programs from path
# Otherwise, n installer will complain about windows
# versions of node/npm
temp_path=`echo $temp_path | tr : '\n' | grep -v "/mnt/c" | grep -v "/cygdrive/c" | paste -s -d: `

PATH="$temp_path"

# Append results of n install script download
