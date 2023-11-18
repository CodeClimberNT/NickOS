# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

# Enable to use home manager
let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Enable to use home manager
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot = {
    extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
    # blacklistedKernelModules = [ "nouveau" "nvidia_drm" "nvidia_modeset" "nvidia" ];

    initrd.kernelModules = [ "i915" ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;

        minegrub-theme.enable = true;

      };
    };
  };


  services.power-profiles-daemon.enable = false;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  services = {
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 60;
        STOP_CHARGE_THRESH_BAT0 = 70;

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
    };

    auto-cpufreq = {
      enable = true;
    };
  };




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

  # hardware for nvidia
  hardware = {
    nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Do not disable this unless your GPU is unsupported or if you have a good reason to.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  hardware = {
    bluetooth.enable = true;
  };

  services.xserver = {
    enable = true;

    layout = "us,it";
    xkbVariant = "";

    videoDrivers = [ "nvidia" ];

    # Enable Plasma5 Desktop Environment
    desktopManager = {
      plasma5.enable = true;
    };

    displayManager = {
      sddm.enable = true;
      sddm.autoNumlock = true;
      defaultSession = "plasma";
    };
  };

  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      gwenview
      okular
      oxygen
      khelpcenter
      konsole
      plasma-browser-integration
      print-manager
    ];
    # enable for wayland
    # sessionVariables.NIXOS_OZONE_WL = "1";
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


  services.gvfs.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nick = {
    isNormalUser = true;
    description = "Nick";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    # shell = pkgs.zsh;
  };




  services.flatpak.enable = true;

  nixpkgs.config =
    let
      unstableTarball =
        fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    in
    {
      packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };

      pulseaudio = true;
      allowUnfree = true;
    };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    let
      nvidia-offload = writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only

        exec "$@"
      '';
    in
    [
      # Stable Channel
      authy
      autojump
      bat
      # brave
      efibootmgr
      firefox
      flatpak
      gh
      git
      gparted
      gvfs
      htop

      jdk
      jdk8
      jdk17

      jetbrains.jdk

      jetbrains-toolbox

      kitty
      libsForQt5.kate
      libsForQt5.kdeconnect-kde
      libreoffice-qt
      lutris
      lshw
      neofetch
      neovim
      nixpkgs-fmt
      obs-studio
      oh-my-zsh
      python311
      qemu
      remmina
      steam
      telegram-desktop
      thunderbird
      tldr
      toybox
      trashy
      vim
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      wget
      zsh

      # virtual manager
      virt-manager

      # Unstable Channel
      vscode
      # unstable.jetbrains.idea-ultimate

      # Linux Packages
      linuxPackages.nvidia_x11

      # Nvidia offload
      nvidia-offload
    ];

  virtualisation.libvirtd.enable = true;

  # Home Manager example (insert non system package)
  # home-manager.useGlobalPkgs = true;
  # home-manager.users.nick = { lib, pkgs, ... }: {
  #     home.stateVersion = "23.05";

  #     # home.packages = with pkgs; [ 
  #     #     zsh
  #     #     zsh-powerlevel10k
  #     # ];
  #     dconf.settings = {
  #       "org/virt-manager/virt-manager/connections" = {
  #         autoconnect = ["qemu:///system"];
  #         uris = ["qemu:///system"];
  #       };
  #     };

  #     #     zsh = {
  #     # enable = true;

  #     # ohMyZsh = {
  #     #   enable = true;
  #     #   # theme = "powerlevel10k";
  #     # };
  #     plugins = [
  #       {
  #         name = "powerlevel10k";
  #         src = pkgs.zsh-powerlevel10k;
  #         file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  #       }
  #       {
  #         name = "powerlevel10k-config";
  #         src = ./p10k-config;
  #         file = "p10k.zsh";
  #       }
  #     ];

  # };

  programs = {
    dconf = {
      enable = true;
    };

    steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;

      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
    };

    #     xwayland.enable = true;

    zsh = {
      enable = true;

      ohMyZsh = {
        enable = true;
        # theme = "powerlevel10k";
      };
      # plugins = [
      #   {
      #     name = "powerlevel10k";
      #     src = pkgs.zsh-powerlevel10k;
      #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      #   }
      #   {
      #     name = "powerlevel10k-config";
      #     src = ./p10k-config;
      #     file = "p10k.zsh";
      #   }
      # ];
    };

    direnv.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  # Open ports in the firewall.
  networking = {
    hostName = "nixos-laptop-nick"; # Define your hostname.

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
    };
    #   wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    # Do Not Change
    stateVersion = "23.05"; # Did you read the comment?

    autoUpgrade = {
      allowReboot = false;
      channel = "https://nixos.org/channels/nixos-23.05";
      enable = true;
      dates = "daily";
    };
  };

  # Garbage Collector
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
