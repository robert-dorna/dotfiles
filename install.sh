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
mkdir -p "$HOME/.config/Code - Insiders/User"
ln -fs "$PWD/config/vscode/settings.json" "$HOME/.config/Code - Insiders/User/settings.json"

code-insiders --install-extension vscodevim.vim
code-insiders --install-extension eamodio.gitlens
code-insiders --install-extension usernamehw.errorlens
code-insiders --install-extension vscode-icons-team.vscode-icons

## vscode - AI
code-insiders --install-extension github.copilot
code-insiders --install-extension github.copilot-chat

## vscode - Devops
code-insiders --install-extension jnoortheen.nix-ide
code-insiders --install-extension ms-azuretools.vscode-docker
code-insiders --install-extension ms-vscode-remote.remote-containers
code-insiders --install-extension ms-vscode-remote.remote-ssh
code-insiders --install-extension github.vscode-github-actions

## vscode - Python
# ms-python.python

## vscode - JS/TS/Node
code-insiders --install-extension dbaeumer.vscode-eslint
code-insiders --install-extension esbenp.prettier-vscode
code-insiders --install-extension bradlc.vscode-tailwindcss
code-insiders --install-extension svelte.svelte-vscode

# npm configuration for global installs
npm set prefix ~/.npm-global
mkdir -p ~/.npm-global
# npx should work with just above, to ommit npx add ~/.npm-global/bin to $PATH
