#!/usr/bin/env bash

if [ -z "$HD" ]; then
	echo "error: first set the \$HD (dotfiles path) env variable"
	exit 1
fi

ln -is $HD/bashrc ~/.bashrc
ln -is $HD/gitconfig ~/.gitconfig
ln -iTs $HD/nvim ~/.config/nvim
