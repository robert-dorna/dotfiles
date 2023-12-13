#!/usr/bin/env bash

## bash
ln -fs "$PWD/config/bash/bash_profile" ~/.bash_profile
ln -fs "$PWD/config/bash/bashrc" ~/.bashrc

## git
ln -fs "$PWD/config/git/gitconfig" ~/.gitconfig

## i3
ln -fTs "$PWD/config/i3" ~/.config/i3

## nixpkgs
ln -fTs "$PWD/config/nixpkgs" ~/.config/nixpkgs

## nushell
mkdir -p "$HOME/.config/nushell"
ln -fs "$PWD/config/nushell/config.nu" ~/.config/nushell/config.nu
ln -fs "$PWD/config/nushell/env.nu" ~/.config/nushell/env.nu

## nvim
ln -fTs "$PWD/config/nvim" ~/.config/nvim

## urxvt
ln -fs "$PWD/config/urxvt/Xresources" ~/.Xresources

## vscode
mkdir -p "$HOME/.config/Code/User"
ln -fs "$PWD/config/vscode/settings.json" ~/.config/Code/User/settings.json

