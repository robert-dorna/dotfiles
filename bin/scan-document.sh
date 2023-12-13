#!/usr/bin/env bash

OUTPUT_FILE=$1

if [ "$OUTPUT_FILE" = "" ]; then
  echo "usage: scan-document.sh <output_filename> (without extension as it will always be .png)"
  echo "error: missing <output_filename>"
  exit 1
fi

if [ -e "$OUTPUT_FILE.png" ]; then
  echo "usage: scan-document.sh <output_filename> (without extension as it will always be .png)"
  echo "error: <output_filename> already exists"
  exit 2
fi

# 006 as devices worked for right USB slot
# resolution 1200 is very detailed but long
scanimage -d 'genesys:libusb:001:011' -o "$OUTPUT_FILE.png" --mode Color --resolution 300
