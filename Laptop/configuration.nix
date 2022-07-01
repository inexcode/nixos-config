# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./software.nix
      ./modules/gnome.nix
      # ./modules/i3.nix
      ./modules/zsh.nix
      ./pipewire.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    # allowBroken = true;
    android_sdk.accept_license = true;
    chromium.enableWideVine = true;
  };

  nixpkgs.overlays = [
    (self: super:
      {
        vscode-extensions = super.vscode-extensions // {
          github.copilot = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              publisher = "github";
              name = "copilot";
              version = "1.30.6165";
              sha256 = "2Y4zQphaPzTjvOJ4EluaVNFksJ2/PL7UE5ceAW7da6Q=";
            };
          };
        };
      }
    )
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking

  networking = {
    hostName = "inex-hp-envy";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp7s0 = {
        useDHCP = true;
      };
      wlp8s0 = {
        useDHCP = true;
      };
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [ 3979 1716 51820 24642 ];
      allowedUDPPorts = [ 3979 1716 51820 24642 ];
    };
    hosts = {
      "195.201.86.153" = [ "derpy" "server" ];
      "64.227.64.222" = [ "wireguard" ];
      "192.168.1.2" = [ "openhab" ];
      "188.126.61.194" = [ "home" ];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.2/24" ];
        privateKeyFile = "/home/inex/wireguard-keys/private";
        peers = [
          {
            publicKey = "8sEAHYhydEGKTVecXcOb28zeGHGLGCsri5evbSQV8mY=";
            allowedIPs = [ "10.100.0.0/24" ];
            endpoint = "135.181.97.221:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # BLuetooth and audio
  sound.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
    sane = {
      enable = true;
      brscan4.enable = true;
    };
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # List services that you want to enable:

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  services.flatpak.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "colemak";
    videoDrivers = [ "nvidia" ];
    libinput.enable = true;
    exportConfiguration = true;
    wacom.enable = true;
    #xkbOptions = "eurosign:e";
    #displayManager.startx.enable = true;
  };

  boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ];
  services.udev.packages = [ pkgs.rtl-sdr ];

  # Video driver
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      prime = {
        offload.enable = true;
        # allowExternalGpu = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  programs = {
    adb.enable = true;
    java = {
      enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };

  hardware.steam-hardware.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    inex = {
      isNormalUser = true;
      home = "/home/inex";
      description = "Inex Code";
      extraGroups = [ "wheel" "user-with-access-to-virtualbox" "networkmanager" "jackaudio" "audio" "video" "adbusers" "docker" "scanner" "lp" "plugdev" ]; # Enable ‘sudo’ for the user.
    };

  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?}

  environment.shellInit = ''
    export VST_PATH=/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst
    export LXVST_PATH=/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst
    export LADSPA_PATH=/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa
    export LV2_PATH=/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2
    export DSSI_PATH=/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi
    export VST3_PATH=/nix/var/nix/profiles/default/lib/vst3:/var/run/current-system/sw/lib/vst3:~/.vst3
  '';



}
