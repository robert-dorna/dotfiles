# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # hardware
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  # network 
  networking.hostName = "Spectre"; 
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 19000 19001 19002 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];
  };

  # timezone and i18n
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # i3wm
  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;

    layout = "pl";
    # xkbVariant = "workman,";
    # xkbOptions = "grp:win_space_toggle";
    
    desktopManager = {
      xterm.enable = false;
    };
    
    displayManager = {
      defaultSession = "none+i3";
    };
    
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

  # programs
  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [ vim-nix ]; 
        opt = [];
      };
      customRC = ''
        luafile /home/ssurrealism/.config/nvim/init-nix.lua
      '';
    };
  };  

  # touchpad and sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  services.xserver.libinput.enable = true;

  # user account
  users.users.ssurrealism = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "vboxusers" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
    ];
  };

  virtualisation.virtualbox.host.enable = true;


  environment.systemPackages = with pkgs; [
    sqlite
    sd
    redshift
    shellcheck
    ranger
    vscode
    volctl
    rxvt_unicode
    evince
    signal-desktop
    brightnessctl
    marktext
    drawio
    tree

    jq
    yq-go
    git
    nodejs

    python39
    poetry
    jupyter

    # min browser
    # fast-cli
    # pup
  ];

  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
  #  "vscode"
  # ];

  nixpkgs.config.allowUnfree = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

