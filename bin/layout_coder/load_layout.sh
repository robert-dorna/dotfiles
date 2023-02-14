#!/usr/bin/env bash

workspaceFile=$HOME/Projects/dotfiles/nixos/layout_coder/workspace.json

if [ -z "$1" ]; then
  echo "error: give a destination workspace number"
  exit 1
fi

i3-msg "workspace $1; append_layout $workspaceFile"

(urxvt -e bash -c 'nixpy.sh shell left' &)
sleep 1
(urxvt -e bash -c 'nixpy.sh shell right' &)
sleep 1
(urxvt -e bash -c 'nixpy.sh shell' &)
