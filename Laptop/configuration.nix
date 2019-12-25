# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./software.nix
      ./modules/gnome.nix
      ./modules/zsh.nix
    ];

  nixpkgs.config.allowUnfree = true;

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
      allowedTCPPorts = [ 1716 ];
      allowedUDPPorts = [ 1716 ];
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
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
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
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "intel" "nv" ];
    libinput.enable = true;
    exportConfiguration = true;
    wacom.enable = true;
    #xkbOptions = "eurosign:e";
    #displayManager.startx.enable = true;
  };

  # Video driver
  hardware = {
    bumblebee = {
      enable = true;
      driver = "nouveau";
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    }; /*
    nvidia = {
      modesetting.enable = true;
      optimus_prime = {
        enable = true;
        allowExternalGpu = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    }; */
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.inex = {
    isNormalUser = true;
    home = "/home/inex";
    description = "Inex Code";
    extraGroups = [ "wheel" "networkmanager" "jackaudio" "audio" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?}


}

