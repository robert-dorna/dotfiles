input@{ config, pkgs, ... }:
import ./shared.nix (input // {
  ## names
  hostName = "Veteran";
  userName = "robert_dorna";
}) //
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
