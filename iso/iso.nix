# This module defines a small NixOS installation CD.
# It does not contain any graphical stuff.
{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # network
  networking.hostName = "ButlerPod";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8080 8081 19000 19001 19002 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];
  };

  # timezone and i18n
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # printing
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # fonts
  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  # user account
  users.users.butler = {
    isNormalUser = true;
    password = "butler";
    extraGroups = [ "wheel" "audio" "docker" ];
  };

  # programs

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA bbbbbbbbbbb@ccccccc"
  ];

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    ## basics
    ranger
    neovim
    git

    ## sysadmin & scripting
    file
    tree
    shellcheck
    jq
    yq-go
    sd
    unzip
    wget
    htop

    ## programming
    ngrok

    ## sql, python, node & c++
    sqlite
    python39
    nodejs
    gcc
  ];

  nixpkgs.config.allowUnfree = true;
}
