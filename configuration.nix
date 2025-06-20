# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  tex =
    pkgs.texlive.combine
    {
      # latex packages
      inherit
        (pkgs.texlive)
        scheme-full
        latexmk
        ;
    };
  unstable = import <nixpkgs-unstable> {};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  # v4l2loopback kernel module is required for obs virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow user to set their time zone.
  time.timeZone = lib.mkForce null;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true; # login screen
    desktopManager.gnome.enable = true; # gnome desktop
  };
  xdg = {
    terminal-exec = {
      enable = false; # doesn't seem to be working
      package = pkgs.alacritty;
    };
  };
  environment.gnome.excludePackages = with pkgs; [
    baobab # disk usage analyzer
    epiphany # web browser
    simple-scan # document scanner
    totem # video player
    yelp # help viewer
    evince # document viewer
    file-roller # archive manager
    geary # email client
    seahorse # password manager
    snapshot #webcam tool
    loupe #image viewer

    # these should be self explanatory
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
    gnome-screenshot
    gnome-calculator
    pkgs.gnome-connections
    pkgs.gnome-text-editor
    pkgs.gnome-console
    pkgs.gnome-tour
    pkgs.gnome-photos

    # Actually want to keep using these, but listing for reference
    # gnome-disk-utility
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.xserver.excludePackages = [
    pkgs.xterm
  ];

  # Define laptop closing behavior
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitchExternalPower = "lock";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # low-latency setup for applications using the pulse backend
    extraConfig.pipewire-pulse."92-low-latency" = {
      "context.properties" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {};
        }
      ];
      "pulse.properties" = {
        "pulse.min.req" = "64/48000";
        "pulse.default.req" = "64/48000";
        "pulse.max.req" = "64/48000";
        "pulse.min.quantum" = "64/48000";
        "pulse.max.quantum" = "64/48000";
      };
      "stream.properties" = {
        "node.latency" = "64/48000";
        "resample.quality" = 1;
      };
    };
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    # low-latency setup
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 64;
      };
    };
  };
  services.tailscale.enable = true;

  # Enable support for Bluetooth devices
  # https://nixos.wiki/wiki/Bluetooth
  hardware.bluetooth = {
    enable = true;
    # Turn on bluetooth hardware at boot
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "dual";
        # show charge of bluetooth devices
        Experimental = "true";
      };
      Policy = {
        # Don't enable bluetooth connections automatically
        AutoEnable = "false";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amurphy = {
    isNormalUser = true;
    description = "Aidan Murphy";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
    packages = with pkgs; [
      #freecad # CAD softward
      #snapmaker-luban # 3D printing
      gimp # image editing
      keepassxc # password manager
      eartag # music file tagger
      #texworks # LaTeX editor
      inkscape # image editor and design tool
      legcord # fork of discord -- group chat and forum
      audacity # audio editor
      nextcloud-client # self-hosted cloud platform
      thunderbird # email client
      obs-studio # video capture

      yazi # terminal file browser
    ];
  };

  programs.steam = {
    enable = true;
  };
  # Allow specific unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox # web browser
    neovim # tui IDE
    alacritty # terminal
    git # version control
    # video/audio editing and conversion
    (ffmpeg.override {
      withXcb = true;
    })
    ffmpegthumbnailer # thumbnails for video file
    fd # better find utility
    ripgrep # fast search
    jq # command line json parsing
    unar # winrar-style file zip/unzip utility
    poppler_utils # pdf rendering
    zoxide # improved cd cli tool
    fzf # fuzzy finder
    # use ueberzugpp from unstable until it works in nix stable
    # https://github.com/jstkdng/ueberzugpp
    # it doesn't work in gnome wayland anyway, but I'm hoping one day I'll
    # update and it'll just magically start working
    unstable.ueberzugpp # preview for images in the terminal
    calc # terminal calculator
    gcc # gnu c compiler
    nodejs # javascript runtime
    gnumake # executable generation
    wl-clipboard # cli clipboard utility
    wget # retrieve content from web servers
    unzip # unzipping utility
    mpv # media player
    libinput # handle input devices in wayland compositors
    feh # image viewer
    btop # better system monitor cli
    lsd # better ls utility for terminal
    bat # better cat utility for terminal
    protonvpn-gui # GUI for Proton VPN
    alejandra # formatting for nixpkgs
    libreoffice # suite of office tools
    zathura # pdf viewer
    tex # custom-defined set of latex utilities
    docker # consistent package shipping
    localsend # send files across devices

    go # golang software
    cargo # rust project build and dependency management
    rustup # rust toolchain installer
    rustc # rust compiler
    lua # lua coding

    gnome-tweaks # support gnome desktop extensions
    gnomeExtensions.appindicator # add app indicator
    gnomeExtensions.blur-my-shell # visual tweak to app view
    gnomeExtensions.just-perfection # finely tweak gnome desktop
    gnomeExtensions.custom-accent-colors # add accent colors to gnome desktop
    # xdg-terminal-exec isn't working at the moment
    # xdg-terminal-exec # allow launching terminal apps in custom terminal
  ];

  # enable the docker daemon
  virtualisation.docker.enable = true;

  # gnome-settings-daemon udev rules required for systeay icons
  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  # Add additional font options
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Fix for dynamic libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackeged programs here.
    # to find the required libraries, use ldd [binary]
    # https://github.com/Mic92/nix-ld?tab=readme-ov-file#Usage
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; #Did you read the comment?

  # Automatically update
  system.autoUpgrade = {
    enable = true;
  };
  # Get upgrade timer status:
  # systemctl status nixos-upgrade.timer
  # Print upgrade log:
  # systemctl status nixos-upgrade.service
  # even with automatic upgrades, you still need to periodically switch to
  # the newest channel with:
  # sudo nix-channel --add [newest version of nixos] nixos
  # E.G. sudo nix-channel --add http://nixos.org/channels/nixos-24.05
  # afterwords, run sudo nixos-rebuild switch
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # Get garbage collection service status:
  # sustemctl nix-gc.service

  # Remove NixOs manual documentaiton app
  documentation.nixos.enable = false;
}
