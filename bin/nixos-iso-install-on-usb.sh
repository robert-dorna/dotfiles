#!/usr/bin/env bash

echo "note: make sure all partitions on the specified device are unmounted"
echo "note: e.g. valid could be /dev/sdb (without number) if pendrive is unmounted"

if ! [ -f "$1" ]; then
  echo "usage: $(basename $0) <input_file> <block_file>"
  echo "error: <input_file> is not a regular file"
  exit 1
fi

if ! [ -b "$2" ]; then
  echo "usage: $(basename $0) <input_file> <block_file>"
  echo "error: <block_file> is not a block file"
  exit 1
fi

# sudo dd if="$1" of="$2" bs=4M conv=fsync
sudo dd if="$1" of="$2" bs=4M conv=fdatasync status=progress
