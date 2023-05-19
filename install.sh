#!/usr/bin/env bash

ln -is $PWD/config/bashrc ~/.bashrc
ln -is $PWD/config/gitconfig ~/.gitconfig
ln -is $PWD/config/Xresources ~/.Xresources
ln -is $PWD/config/i3 ~/.config/i3
ln -iTs $PWD/config/nvim ~/.config/nvim
ln -iTs $PWD/config/nixpkgs ~/.config/nixpkgs
ln -iTs $PWD/config/background-image ~/.background-image

echo "go to config/ and create a symlink to ../wallpapers/ that you want named 'background-image'"
