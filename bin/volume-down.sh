#!/usr/bin/env bash

# TODO: write C++ REST server that controls volume
# and responsibe web broser frontend would be cool,
# with e2ee encryption by QR would be awesome

pactl set-sink-volume @DEFAULT_SINK@ -10%

