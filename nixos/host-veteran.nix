input@{ config, pkgs, lib, ... }:
lib.recursiveUpdate (import ./host-shared.nix (input // rec {
  ## names
  hostName = "Veteran";
  userName = "robert_dorna";
  sshKeyPath = /home + "/${userName}/.ssh/veteran.pub";
}))
{
  ## booting
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
    extraEntries = ''
      menuentry "Windows 10" {
        chainloader (hd0,1)+1
      }
    '';
  };
}
