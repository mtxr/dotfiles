#!/bin/bash

if [ -f $HOME/.gitconfig ];then
    cat $HOME/.gitconfig | grep 'gitconfig_defaults' && exit 0
    echo "Linking gitconfig defaults"
fi

(
    /usr/bin/cat <<EOF
[include]
	path = ~/.dotfiles/rcfiles/gitconfig_defaults
EOF
) | tee -a $HOME/.gitconfig &> /dev/null