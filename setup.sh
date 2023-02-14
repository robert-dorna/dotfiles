#!/bin/bash


# programs izolation (no access to internet, file system etc.)
# security
# simple
# i3 

if [ `uname` = "Linux" ]; then
  sudo pacman -Syyu
  sudo pacman -S --needed go-yq go git nodejs npm
  sudo pacman -S --needed pulseaudio-alsa pulseaudio-bluetooth bluez-utils
  sudo pacman -S --needed pavucontrol
  sudo pacman -S --needed redshift
  sudo pacman -S --needed min

  marktext x86_64 AppImage 
  drawio x86_64 AppImage

  #go install github.com/ericchiang/pup@latest   # todo: only if needed
  #sudo npm install -g fast-cli                  # todo: only if needed
  # todo: invert scroll
fi




