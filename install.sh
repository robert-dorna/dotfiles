#!/usr/bin/env bash

ln -is $PWD/config/bash_profile ~/.bash_profile
ln -is $PWD/config/bashrc ~/.bashrc
ln -is $PWD/config/gitconfig ~/.gitconfig
ln -is $PWD/config/Xresources ~/.Xresources

ln -iTs $PWD/config/alacritty ~/.config/alacritty
ln -iTs $PWD/config/i3 ~/.config/i3
ln -iTs $PWD/config/nvim ~/.config/nvim
ln -iTs $PWD/config/nixpkgs ~/.config/nixpkgs
ln -iTs $PWD/config/background-image ~/.background-image

echo "to setup wallpaper, create a symlink 'config/background-image' to 'wallpapers/<your-pick>'"

if [ "$(hostname)" = "Spectre" ]; then
  if ! [ -d "$HOME/veteran" ]; then
    mkdir $HOME/veteran
  fi
elif [ "$(hostname)" = "Veteran" ]; then
  if ! [ -d "$HOME/spectre" ]; then
    mkdir $HOME/spectre
  fi
fi

if ! [ -d "$HOME/usb" ]; then
  mkdir $HOME/usb
fi
