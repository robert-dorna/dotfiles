# Custom ISO for LiveCD/USB boot

NixOS offers you an option to build you own custom .iso image instead of downloading one.

See: https://nixos.wiki/wiki/Creating_a_NixOS_live_CD.

I'm using this feature to create an .iso with docker and ngrok on it which I sometimes
use on my old computers to host dockerized apps.

### building image

    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    
### writing image to usb

    dd if=result/iso/nixos-*.iso of=/dev/sdX bs=4M status=progress conv=fdatasync  # replace sdX with your usb stick

### testing image locally on VM

    qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso  # requires 'qemu' package
