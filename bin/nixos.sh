#!/usr/bin/env bash

## this script is not ready,
## I concatenated 3 scripts to one and left it at that (only added comments)
exit 1

##
## Download ISO
## 

URL="https://channels.nixos.org/nixos-23.05"
ISO="latest-nixos-minimal-x86_64-linux.iso"
SHA="latest-nixos-minimal-x86_64-linux.iso.sha256"

echo "[1/4] downloading .iso ..."
wget "$URL/$ISO"
echo "[1/4] downloading .iso ... done"

echo "[2/4] downloading .iso.sha256 ..."
wget "$URL/$SHA"
echo "[2/4] downloading .iso.sha256 ... done"

echo "[3/4] renaming files ..."
ISO_CORRECT="$(cat $SHA | awk "{print \$2}")"
SHA_CORRECT="${ISO_CORRECT}.sha256"
mv "$ISO" "$ISO_CORRECT"
mv "$SHA" "$SHA_CORRECT"
echo "[3/4] renaming files ... done"

echo "[4/4] checking checksum ..."
sha256sum --check $SHA_CORRECT
echo "[4/4] checking checksum ... done"

##
## Write ISO
## 

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

##
## Install ISO
## 

echo "> Manual installation - making font bigger"
setfont ter-v32n

echo "> Networking the installer"

echo ">> you need to set it up"
echo ">> run: sudo systemctl start wpa_supplicant"
echo ">> run: wpa_cli"
echo ">> run:   scan"
echo ">> run:   scan_results"
echo ">> run:   add_network 0"
echo '>> run:   set_network 0 ssid "Robert Hotspot"'
echo ">> run:   set_network 0 key_mgmt NONE"
echo ">> run:   enable_network 0"
echo ">> run:   quit"

echo "> Partitioning and formatting - UEFI (GPT)"

sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart primary 512MB -108GB
sudo parted /dev/sda -- mkpart primary -108GB -8GB
sudo parted /dev/sda -- mkpart primary linux-swap -8GB 100%
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 4 esp on

echo "> Partitioning and formatting - formatting"

sudo mkfs.ext4 -L nixos /dev/sda1
sudo mkfs.ext4 -L storage /dev/sda2
sudo mkswap -L swap /dev/sda3
sudo mkfs.fat -F 32 -n boot /dev/sda4

echo "> Installing"

sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/sda3
sudo nixos-generate-config --root /mnt

echo "> note: edit /mnt/etc/nixos/configuration.nix"
echo "> run: nixos-install"
