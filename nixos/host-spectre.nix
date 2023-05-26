input@{ config, pkgs, lib, ... }:
lib.recursiveUpdate (import ./host-shared.nix (input // {
  ## names
  hostName = "Spectre";
  userName = "ssurrealism";
}))
{
  ## booting
  hardware.enableAllFirmware = true;
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=1
    '';
  };

  ## printing
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        hplip
        hplipWithPlugin
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
      ];
    };
  };
}

