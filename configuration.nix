# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
# Enable to use home manager
# let
#   home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Enable to use home manager
      # (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };


  networking.hostName = "nixos-desktop"; # Define your hostname.
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

  # Configure X11
  services.xserver = {
    enable = true;
    
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
      };
      # autoLogin = {
      #     enable = true;
      #     user = "nick";
      # };
    };
    # Set Layout And Variant
    layout = "us,it";
    xkbVariant = "";
  };


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
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
    packages = with pkgs; [    ];
  };
  
  
  # Home Manager example (insert non system package)
  # 
  # home-manager.users.nick = { pkgs, ... }: {
  #     home.stateVersion = "23.05";
  #     home.packages = with pkg; [  
  #       htop
  #     ];
  # };

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
    flatpak
    gh
    htop
    kitty
    lutris
    neofetch
    neovim
    qemu
    steam
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

  # Enable Plex Media Server

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.plex.enable = true;

  # Enable Remote Desktop Protocol
  services.xrdp = {
    enable = true;
    openFirewall = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
