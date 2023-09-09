#!/usr/bin/env bash

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
