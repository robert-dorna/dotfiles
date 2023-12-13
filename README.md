# dotfiles

My set of files for OS and packages configuration. I'm using [NixOS](https://nixos.org).

My hardware:

- main laptop named "Spectre"
- secondary laptop named "Veteran" + external VGA monitor
- Raspberry PI 2 B+
- old stationary PC (with Windows and hard drives that I cannot use or format)

### Installation

On a fresh NixOS installed on laptop "Spectre", I run:

```shell
nix-shell -p git
git clone https://github.com/robert-dorna/dotfiles
exit
cd dotfiles/nixos
nixos-rebuild -I nixos-config=./host-spectre.nix boot
reboot
```

And then after reboot:

```shell
cd dotfiles
./install.sh
```

On "Veteran" laptop I do the same but for `./host-veteran.nix`.

### Custom ISO for bootable LiveCD/USB stick

See: https://nixos.wiki/wiki/Creating_a_NixOS_live_CD.

I'm using this feature to create a custom .iso for USB boot with docker, ngrok and other devops stuff, which I sometimes use on my old PC to host my dockerized apps without affecting PC hard drives.

TODO: `livecd.nix` should be defining a normal iso optimized for being run from pendrive without installer logic.

#### build image

```shell
cd nixos
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=livecd.nix
```

#### test image locally on VM

requires `qemu` package (run `nix-shell -p qemu` if you don't have it)

```shell
qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso
```

#### write image to USB stick

replace `sdX` with your USB stick (you can run `lsblk` before and after plugging in USB stick to see which it is)

```shell
dd if=result/iso/nixos-*.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
```

### TODO

- Utilize Nix, Docker, Nushell and AI more, reduce Bash etc.

- One command to get .iso on USB stick (potentially download or generate, and setup), and one command inside that .iso to install my OS on new machine.

- Sync all my private data between computers and encrypted on cloud

- I could be using nix user profiles (additional environments) and not just define all programs as system packages (system environment)

- I could use nix to define/handle more stuff (e.g. neovim settings, bashrc, vscode extensions, python modules, i3 config, ...)

- I could use Flakes cuz AFAIK they are important and maybe a way to go right now: [In 2023, you shouldn’t be using nix-env or niv or shell.nix but rather just use ... | Hacker News](https://news.ycombinator.com/item?id=35039490)

- sync screen lock and maybe unlock (that could be risky) between laptops and with my phone

- automatic locking when away and general synchronization with phone

- any computer on any screen via remote sharing, e.g. xrdp, but also needs to be secure