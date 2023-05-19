# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  ## hardware
  imports = [ ./hardware-configuration.nix ];

  ## hardware Spectre
  # hardware.enableAllFirmware = true;
  # boot = {
  #   loader = {
  #     systemd-boot.enable = true;
  #     efi.canTouchEfiVariables = true;
  #   };
  #   extraModprobeConfig = ''
  #     options snd-intel-dspcfg dsp_driver=1
  #   '';
  # };

  ## hardware Veteran
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

  ## network
  networking = {
    hostName = "Veteran";  # or "Spectre"
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8080 8081 19000 19001 19002 ];
      allowedUDPPortRanges = [
        { from = 4000; to = 4007; }
        { from = 8000; to = 8010; }
      ];
    };
  };

  ## touchpad and sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  services.xserver.libinput.enable = true;
  
  ## timezone and i18n
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  
  ## fonts
  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  ## printing
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
  services.printing = {
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

  ## i3wm
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;
    layout = "pl";
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3lock-fancy-rapid
      ];
    };
  };  

  ## users
  # services.openssh.enable = true;
  users.users.robert_dorna = {
    isNormalUser = true;
    # note: docker group is a vuln! (root escalation) (https://nixos.wiki/wiki/Docker)
    extraGroups = [ "wheel" "audio" "docker" "adbusers" /*"vboxusers*/ ];
    packages = with pkgs; [
      firefox
      # min browser
    ];
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA bbbbbbbbbbb@ccccccc"
    # ];
  };

  ## programs
  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  programs.adb.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [ vim-nix ];
        opt = [];
      };   
      customRC = ''
        luafile /home/robert_dorna/.config/nvim/init-nix.lua
      '';
    };
  };
  nixpkgs.config.allowUnfree = true;  # todo: make this only for vscode
  environment.systemPackages = with pkgs; [
    ## basics
    ranger
    rxvt_unicode
    git

    ## look & feel
    redshift
    volctl
    brightnessctl

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
    gparted
    # fast-cli
    # pup

    ## social stuff
    signal-desktop
    discord

    ## documents
    marktext
    drawio
    evince

    ## programming
    vscode
    ngrok
    minikube
    kompose
    postman
    cloc
    
    ## android
    android-studio
    bundletool
    scrcpy

    ## python
    python39
    poetry
    jupyter

    ## node
    nodejs

    ## sql
    sqlite

    ## c++
    gcc
    gdb
    # qtcreator
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

