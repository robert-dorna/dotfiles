{ config, pkgs, lib, hostName, userName, sshKeyPath, ... }:
{
  ## hardware
  imports = [ /etc/nixos/hardware-configuration.nix ];

  ## network
  networking = {
    hostName = hostName;
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
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  services.xserver.libinput.enable = true;
  services.blueman.enable = true;
  
  ## timezone and i18n
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  
  ## fonts
  fonts.fonts = with pkgs; [
    nerdfonts
    hermit
    source-code-pro
    terminus_font
  ];

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
  services.openssh.enable = true;
  users.users."${userName}" = {
    isNormalUser = true;
    # note: docker group is a vuln! (root escalation) (https://nixos.wiki/wiki/Docker)
    extraGroups = [ "wheel" "audio" "docker" "adbusers" /*"vboxusers*/ ];
    packages = with pkgs; [
      firefox
      # min browser
    ];
    openssh.authorizedKeys.keys = [
      (lib.removeSuffix "\n" (lib.readFile sshKeyPath))
    ];
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
        luafile /home/${userName}/.config/nvim/init.lua
      '';
      # luafile /home/${userName}/.config/nvim/init-nix.lua
    };
  };
  nixpkgs.config.allowUnfree = true;  # todo: make this only for vscode
  environment.systemPackages = with pkgs; [
    ## basics
    ranger
    rxvt_unicode
    zellij
    git

    ## look & feel
    redshift
    volctl
    brightnessctl

    ## sysadmin & scripting
    acpi
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
    sshfs
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
    alacritty
    kitty
    helix
    go-swagger
    dbeaver
    
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

