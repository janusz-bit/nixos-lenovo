# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./15IRX10.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  # users.users.dinosaur.extraGroups = [ "tss" ]; # tss group has access to TPM devices

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "pl_PL.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      splix
    ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dinosaur = {
    isNormalUser = true;
    description = "dinosaur";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "tss"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    nixfmt-rfc-style
    nixd
    # vscodium-fhs
    vscode-fhs
    git
    mangohud
    protonup-qt
    vlc
    discord
    heroic
    signal-desktop
    handbrake
    obsidian
    pandoc
    kdePackages.wallpaper-engine-plugin
    betterdiscordctl
    libreoffice-qt
    hunspell
    hunspellDicts.pl_PL

    neovim
    lazygit
    curl
    fzf
    ripgrep
    fd

    qbittorrent

    clamav
    clamtk

    unzip

    emacs

    nil

    wine64
    winetricks

    universal-android-debloater

    kdePackages.kcalc
    # libsForQt5.kdeconnect-kde

    vim
    nano

    htop

    # nodejs
    nil
    # cargo
    # rustc
    # rustfmt
    # rust-analyzer
    # clippy

    pinta
    gimp3

    # binutils
    # gdb
    # lldb
    # cmake
    # ninja
    # gnumake
    # stremio # UNSAFE FOR NOW 2025-09-17

    # clang
    # gcc

    librewolf
    thunderbird

    virt-manager
    looking-glass-client

    unrar
    wine
    wine64
    proton-caller
    protontricks
    # proton-ge-bin

    brave

    krita

    kdePackages.libkscreen

    dnsmasq

    inputs.nix-alien.packages.${system}.nix-alien

    jdk

    looking-glass-client

    prismlauncher

    megasync

    tor-browser

    kdePackages.kleopatra

    lenovo-legion
  ];

  services.flatpak.enable = true;

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  fonts.packages = with pkgs; [ nerd-fonts._0xproto ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = false;
      extraCompatPackages = [pkgs.proton-cachyos_x86_64_v4 ];
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };
    direnv.enable = true;
    firefox.enable = true;
    gamemode.enable = true;
    partition-manager.enable = true;
    kdeconnect.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
      enableExtraSocket = true;
    };
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.local/share/Steam/compatibilitytools.d";
  };


  hardware.nvidia.open = lib.mkForce true;

  services.syncthing = rec {
    enable = true;
    openDefaultPorts = true;
    user = "dinosaur";
    dataDir = "/home/${user}";
    configDir = "/home/${user}/.config/syncthing";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "7d";

  };

  programs.nix-ld.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.wooting.enable = true;

  # hardware.graphics.enable32Bit = true;

  # Kernel ChacheOS
  boot.kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride { mArch = "GENERIC_V4"; };
  # services.scx.enable = true;

  programs.adb.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
