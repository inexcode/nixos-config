# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./software.nix
      ./modules/gnome.nix
      ./modules/zsh.nix
    ];

  nixpkgs.config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
  };

  fileSystems."/mediastorage" = {
    device = "/dev/disk/by-uuid/aed202ac-7414-40b9-9d71-011b7043c850";
    fsType = "ext4";
  };

  fileSystems."/backups" = {
    device = "/dev/disk/by-uuid/63db910e-f906-4211-bac5-4330777c8283";
    fsType = "ext4";
  };


  networking = {
    hostName = "inex-pc";
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
      allowedTCPPorts = [ 1716 51820 24642 27036 27037 ];
      allowedUDPPorts = [ 1716 51820 24642 27031 27036 ];
    };
    wireguard.interfaces = {
     wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.6/24" ];

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/inex/wireguard-keys/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = "8sEAHYhydEGKTVecXcOb28zeGHGLGCsri5evbSQV8mY=";

          # Forward all the traffic via VPN.
          # allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          allowedIPs = [ "10.100.0.0/24" ];

          # Set this to the server IP and port.
          endpoint = "135.181.97.221:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
   };
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  services = {
    printing.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "colemak";
      videoDrivers = [ "amdgpu" ];
      libinput.enable = true;
      exportConfiguration = true;
      wacom.enable = true;
    };
    openssh = {
      enable = true;
      passwordAuthentication = false;
      forwardX11 = true;
    };
    pipewire.enable = true;
    flatpak.enable = true;
  };


  sound.enable = true;

  # Video driver
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = [ pkgs.amdvlk pkgs.rocm-opencl-icd pkgs.rocm-runtime ];
    };
    steam-hardware.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
  };

  environment.variables.VK_ICD_FILENAMES = "${pkgs.amdvlk}/share/vulkan/icd.d/amd_icd64.json";

  programs = {
    adb.enable = true;
    java = {
      enable = true;
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.inex = {
    isNormalUser = true;
    home = "/home/inex";
    description = "Inex Code";
    extraGroups = [ "wheel" "networkmanager" "jackaudio" "audio" "video" "adbusers" "docker" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzL0gmvpMOZbijqZOlTuNqtVHZGoNrxCiWJXIDcUwr1cx8M2o61qK/wNMZmyYGROpJbpsFERAjXIXBpwg2KQ3ONRL6q44nPrOSbHm3zL8pnFEvzM0BUKV1Mq2T1dM+geMhQnLrwZhOxvp3+9uhFSTPP/dVzWQ19pEiK5hHpXlD3eyO+LIaS/wkTJvBy/wCKz+O/coLyBQ+Mn5hGQaJAyDec/ovu8OhBkJbbvWp03F2zcWUCxwVfZ1VnLQxn7tk9L4iTw1+rDt0kaRQvVISV3KdqLJnPODku6eC38LcMfHIFXAWBdSUslGUl9Qkd1c+6Gorzt3BrfYL/HDW2Xk3UTQF inex-envy"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbUS/AblfzZcfr/iMxHJ5pubzCuriVTu12TKt1iRQFDjQDo+/j0/Ga07zqyB9VUhpJg/IOcJ6o2T4PBixNuHQQX5z4sb/tqzbx3buBz0HIp8VHRC3TtLAmsFj24AldxlADlQpGnlt+g3p200m2dwu/Yoe4+GD8Twwg6FCsyiRjstbfo89Kmwi9yVbXx5aBssscEkXBQODTpwOB05nCz3oUuvQ5ex+yH+o02cTlYyBoglgfzM6HzR0GkmCRDlx613nqa1+ICxwWY0cXMbhnUwDoJASk5eJovtmEqC29qJKABxZaKRYsaW3sMJiMOvPHf9BkVKp4uPINhLc5vopwZI10xsNOn75AXRptkHzenn7ymC+qwJr53Z1tAAfMb5ypJ+u+SE8wazd4x2CIFHH+LbaputqxyfUxNoMbFMGNXICDAOCCQ0nkax7Ifr1NlTp07zTYH6VP0kzqqYiAlBu5qo3qIi5dRsLvb6/McerDNhRmYh25Ww7zpEY4Q9uTWDZkCP8= u0_a122@localhost"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

