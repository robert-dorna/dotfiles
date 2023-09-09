#!/usr/bin/env bash

if [ -n "$1" ]; then
  if [ "${1:0:1}" = "-" ]; then
    eval sudo bluetoothctl disconnect \$BL_${1:1:u}
  else
    eval sudo bluetoothctl connect \$BL_${1:u}
  fi
  exit 0
fi

echo -e '\nbonded:'
bluetoothctl devices Bonded

echo -e '\npaierd:'
bluetoothctl devices Paired

echo -e '\ntrusted:'
bluetoothctl devices Trusted

echo -e '\nconnected:'
bluetoothctl devices Connected
