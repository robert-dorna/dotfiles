{ config, pkgs, lib, hostName, userName, sshKeyPath, systemStateVersion, ... }:
{
  ## hardware
  imports = [ /etc/nixos/hardware-configuration.nix ];

  boot.supportedFilesystems = [ "ntfs" ];

  ## Unfree code
  nixpkgs.config.allowUnfree = true;  # todo: make this only for vscode

  ## Network
  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPortRanges = [
        { from = 4000; to = 4007; }
        { from = 8000; to = 8010; }
      ];
    };
  };
  
  ## Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  ## Sound
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };

  ## Printing
  hardware.sane.enable = true;

  ## Touchpad and Mouse
  services.xserver.libinput.enable = true;
  
  ## Timezone and i18n
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  
  ## Fonts
  fonts.packages = with pkgs; [
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

  ## Users
  services.openssh.enable = true;
  users.users."${userName}" = {
    isNormalUser = true;
    # note: docker group is a vuln! (root escalation) (https://nixos.wiki/wiki/Docker)
    extraGroups = [ "wheel" "audio" "docker" "adbusers" "scanner" "lp" ];
    packages = with pkgs; [
      firefox
      # min browser
    ];
    openssh.authorizedKeys.keys = [
      (lib.removeSuffix "\n" (lib.readFile sshKeyPath))
    ];
  };

  ## Programs
  virtualisation.docker.enable = true;
  programs = {
    adb.enable = true;
    neovim = {
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
      };
    };
  };
  environment.systemPackages = with pkgs; [
    ## Terminal navigation and basic tools
    rxvt_unicode
    zellij
    ranger
    file
    tree
    unzip
    wget
    sshfs
    jmtpfs

    ## System monitoring and administration
    brightnessctl     # screen brightness
    redshift          # screen redness
    volctl            # sound
    acpi              # battery
    htop        
    gparted
    fast-cli          # network speed

    ## Documents and images
    marktext
    drawio
    evince
    gqview

    ## Social
    discord
    # signal-desktop

    ## Scripting
    nushell
    shellcheck
    jq
    yq-go
    sd
    # pup

    ## Programming - base
    ((vscode.override { isInsiders = true; }).overrideAttrs (
      oldAttrs: rec {
        version = "latest";
        src = builtins.fetchTarball {
          url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
          sha256 = "023ryfx9zj7d7ghh41xixsz3yyngc2y6znkvfsrswcij67jqm8cd";
        };
      }
    ))
    # TODO: add extensions to above vscode from below (currently there is no easy way to add it to vscode.override)
    # (vscode-with-extensions.override {
    #   vscodeExtensions = with vscode-extensions; [
    #     ## General
    #     vscodevim.vim
    #     eamodio.gitlens
    #     usernamehw.errorlens
    #     vscode-icons-team.vscode-icons

    #     ## AI
    #     github.copilot
    #     github.copilot-chat

    #     ## Devops
    #     jnoortheen.nix-ide
    #     ms-azuretools.vscode-docker
    #     ms-vscode-remote.remote-containers

    #     ## Python
    #     # ms-python.python

    #     ## JS/TS/Node
    #     dbaeumer.vscode-eslint
    #     esbenp.prettier-vscode
    #     bradlc.vscode-tailwindcss
    #     svelte.svelte-vscode
    #   ];
    # })
    git
    gh
    cloc

    ## Programming - devops
    ngrok
    # minikube
    # kompose

    ## Programming - backend
    # postman
    go-swagger

    ## Programming - database
    # dbeaver
    sqlite

    ## Programming - android
    # android-studio
    # bundletool
    scrcpy

    ## Programming - python
    # python39
    # poetry
    # jupyter

    ## Programming - node
    nodejs

    ## Programming - c++
    # qtcreator
    gcc
    gdb
  ];

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
  system.stateVersion = "${systemStateVersion}"; # Did you read the comment?
}

