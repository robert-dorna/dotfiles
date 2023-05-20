# dotfiles

My set of files for OS configuration.

I'm using [NixOS](https://nixos.org).

I have 2 main computers (and a USB stick for third computer):

- decent laptop named "Spectre"
- old laptop named "Veteran"

Both of them combined with old but good VGA monitor give me a nice big 3 monitors setup.

### Computers setup

On my old laptop, I run below command after which all my programs and OS configuration is done:

```shell
nixos-rebuild -I nixos-config=nixos/host-veteran.nix switch
```

On "Spectre" laptop, I do the same but with `host-spectre.nix`.

It's a very basic nixos/nix setup for now, with many things possible to improve.

For example:

- I could be using nix user profiles (additional environments) and not just define all programs as system packages (system environment)

- I could use nix to define/handle more stuff (e.g. neovim settings, bashrc, vscode extensions, python modules, i3 config, ...)

- I could use Flakes cuz AFAIK they are important and maybe a way to go right now: [In 2023, you shouldn’t be using nix-env or niv or shell.nix but rather just use ... | Hacker News](https://news.ycombinator.com/item?id=35039490)

Also, I strive for a setup that is seamlessly synced, minimalistic and highly efficient so in future I could expand it more and more to something like an OS or DE (and launcher for phone). I even have a name for it: "MomentumOS". Anyway, note to myself what would be cool to have:

- sshfs (or something faster) to mount files and directories of another host

- sync screen lock and maybe unlock (that could be risky)

- any computer on any screen via remote sharing, e.g. xrdp, but also needs to be secure

- automatic locking when away and general synchronization with phone

- all that sync of control, notes, documents, bookmarks, locks,... despite not being in same local network (effectively turning my setup into being also a cloud) ([Tangler](https://github.com/robert-dorna/Tangler) will be self-hostable so it could be utilized here)

### Custom ISO for bootable LiveCD/USB stick

NixOS offers you an option to build you own custom .iso images.

See: https://nixos.wiki/wiki/Creating_a_NixOS_live_CD.

I'm using this feature to create an installer .iso with docker and ngrok on it which I sometimes use on my old stationary computer (not laptops) to host dockerized apps.

The image is defined in `nixos/livecd.nix` and I should be defining a normal iso (I guess optimized for being run on pendrive) instead of installer iso, but that is how I learned that this is even possible so for now it is pointelessly an installer image and in future will be a normal OS but on pendrive.

Also in future I should include in this image few more tools related to devops,  deployment monitoring and management. 

### building image

```shell
cd nixos
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=livecd.nix
```

### writing image to USB stick

replace `sdX` with your USB stick (you can run `lsblk` before and after plugging in USB stick to see which it is)

```shell
dd if=result/iso/nixos-*.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
```

### testing image locally on VM

requires `qemu` package (run `nix-shell -p qemu` if you don't have it)

```shell
qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso
```
