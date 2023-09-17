# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
  };


services.power-profiles-daemon.enable = false;
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelParams = ["intel_pstate=disable"];
    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0=75;
        STOP_CHARGE_THRESH_BAT0=80;
      };
      #   CPU_SCALING_GOVERNOR_ON_AC=schedutil
      #   CPU_SCALING_GOVERNOR_ON_BAT=schedutil

      #   CPU_SCALING_MIN_FREQ_ON_AC=800000
      #   CPU_SCALING_MAX_FREQ_ON_AC=3500000
      #   CPU_SCALING_MIN_FREQ_ON_BAT=800000
      #   CPU_SCALING_MAX_FREQ_ON_BAT=2300000

      #   # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
      #   # A value of 0 disables, >=1 enables power saving (recommended: 1).
      #   # Default: 0 (AC), 1 (BAT)
      #   SOUND_POWER_SAVE_ON_AC=0
      #   SOUND_POWER_SAVE_ON_BAT=1

      #   # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
      #   # Default: on (AC), auto (BAT)
      #   RUNTIME_PM_ON_AC=on
      #   RUNTIME_PM_ON_BAT=auto

      #   # Battery feature drivers: 0=disable, 1=enable
      #   # Default: 1 (all)
      #   NATACPI_ENABLE=1
      #   TPACPI_ENABLE=1
      #   TPSMAPI_ENABLE=1
    };
  networking.hostName = "nixos-laptop-nick"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    layout = "us,it";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
  users.users.nick = {
    isNormalUser = true;
    description = "Nick";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  services.flatpak.enable = true;
  
  nixpkgs.config = 
  let unstableTarball =
    fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    in {
    # Allow unfree packages
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Stable Channel
    authy
    autojump
    brave
    efibootmgr
    flatpak
    gh
    gparted
    htop
    kitty
    libsForQt5.kdeconnect-kde
    lutris
    neofetch
    neovim
    qemu
    steam
    telegram-desktop
    thunderbird
    tldr
    trashy
    vim
    xfce.thunar
    wget

    # Unstable Channel
    unstable.vscode
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system={
    # Do Not Change
    stateVersion = "23.05"; # Did you read the comment?

    autoUpgrade = {
      allowReboot = true;
      channel = "https://nixos.org/channels/nixos-23.05";
      enable = true;
      dates = "daily";
    };
  };

  # Garbage Collector
  nix.gc= {
  	automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

}
