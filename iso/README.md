# TODO: make something from below

#!/usr/bin/env bash

nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
#!/usr/bin/env bash

if ! [ -e "$1" ]; then
  echo "error: iso not found"
  echo "usage: ./install.sh <iso> <block_device> (block device is e.g. /dev/sdb)"
  exit 1
fi

if ! [ -b "$2" ]; then
  echo "error: block_device not found"
  echo "usage: ./install.sh <iso> <block_device> (block device is e.g. /dev/sdb)"
  exit 1
fi

dd if=$1 of=$2 bs=4M status=progress conv=fdatasync
#!/usr/bin/env bash

# nix-shell -p qemu
qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso
