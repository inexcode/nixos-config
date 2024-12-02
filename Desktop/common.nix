# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, fetchpatch, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./software.nix
      ./modules/gnome.nix
      ./modules/zsh.nix
      ./modules/vscode.nix
      # ./lockservice.nix
      # ./vscode.nix
    ];

  nix.settings.trusted-users = [ "root" "inex" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
    chromium = {
      enableWideVine = true;
    };
    permittedInsecurePackages = [
      "olm-3.2.16"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
    grub.memtest86.enable = true;
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };

  boot.supportedFilesystems = [ "btrfs" "ntfs" ];

  networking = {
    hostName = "inex-pc";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp39s0 = {
        useDHCP = true;
      };
      wlo1 = {
        useDHCP = true;
      };
    };
    nameservers = [ "10.100.0.101" "8.8.8.8" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8437 1716 51820 24642 27036 27037 24800 26000 3979 ];
      allowedUDPPorts = [ 8437 1716 51820 24642 27031 27036 24800 26000 3979 ];
      checkReversePath = false;
    };
    wireguard.interfaces = {
      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = [
          "10.100.0.6/24"
        ];
        listenPort = 56987;


        mtu = 1200;


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
            #allowedIPs = [ "0.0.0.0/0" ];
            # Or forward only particular subnets
            allowedIPs = [ "10.100.0.0/24" ];

            # Set this to the server IP and port.
            endpoint = "192.168.1.127:51555";
            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
          {
            # Public key of the server (not a file path).
            publicKey = "33y4aWkI645LztWgQrzkFJphrHQxYvHoduT+1OJQ7m8=";

            # Forward all the traffic via VPN.
            #allowedIPs = [ "0.0.0.0/0" ];
            # Or forward only particular subnets
            allowedIPs = [ "10.100.0.10/32" "10.100.0.11/32" ];

            # Set this to the server IP and port.
            endpoint = "192.168.1.10:51820";

            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }

        ];
      };
      # wg1 = {
        # REDACTED
      # };
      # wg2 = {
        # REDACTED
      # };

    };
    hosts = {
      "192.168.1.10" = [ "homelab.inex.cloud" ];
      "10.100.0.100" = [ "autumn-blaze.inex.cloud" ];
      #"192.168.1.3" = [ "fw.ponychord.rocks" ];
      "127.0.0.1" = [ "traefik.local" ];
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
    yubikey-agent.enable = true;
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin pkgs.cups-brother-dcpt310 ];
    };
    libinput.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.variant = "colemak";
      videoDrivers = [ "modesetting" ];
      exportConfiguration = true;
      wacom.enable = true;
    };
    usbmuxd.enable = true;
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
      };
    };
    ollama = {
      enable = true;
      acceleration = "rocm";
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1100"; # used to be necessary, but doesn't seem to anymore
      };
      rocmOverrideGfx = "11.0.0";
    };
    flatpak.enable = true;
    udev.packages = [
      pkgs.platformio-core
      pkgs.openocd
      pkgs.yubikey-personalization
      (pkgs.writeTextFile {
        name = "yubikey-actions";
        text = ''
          # ACTION=="remove", ENV{ID_MODEL_ID}=="0407", ENV{ID_VENDOR_ID}=="1050", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
          # ACTION=="remove", ENV{HID_NAME}=="Flipper Devices Inc. U2F Token", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
        destination = "/etc/udev/rules.d/50-yubikey-actions.rules";
      })

      (pkgs.writeTextFile {
        name = "wacom_udev";
        text = ''
          KERNEL!="event[0-9]*", GOTO="wacom_end"
          DRIVERS=="wacom", ATTRS{bInterfaceNumber}=="00", ENV{WACOM_TYPE}="stylus"
          DRIVERS=="wacom", ATTRS{bInterfaceNumber}=="01", ENV{WACOM_TYPE}="touch"
          ATTRS{idVendor}=="056a", ENV{WACOM_TYPE}!="touch", SYMLINK+="input/wacom"
          ATTRS{idVendor}=="056a", ENV{WACOM_TYPE}=="touch", SYMLINK+="input/wacom-touch"
          #ATTRS{idVendor}=="056a", ACTION=="add", RUN+="check_driver wacom $devpath $env{ID_BUS}"
          LABEL="wacom_end"
        '';
        destination = "/etc/udev/rules.d/50-wacom.rules";
      })
    ];

  };


  #sound.enable = true;

  # Video driver
  hardware = {
    graphics = {
      enable = true;
      extraPackages = [ pkgs.rocmPackages.clr.icd ];
    };
    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
      brscan4.enable = true;
    };
    steam-hardware.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
    };
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };
  };

  programs = {
    steam = {
      enable = true;
      # package = pkgs.steam.override { privateTmp = false; };
      remotePlay.openFirewall = true;
      gamescopeSession = {
        #enable = true;
        #args = [ "--rt" "-O DP-1" "-W 3440" "-H 1440" "--hdr-enabled" ];
      };
    };
    adb.enable = true;
    java = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    alvr = {
      enable = true;
      openFirewall = true;
    };
    #k3b.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    waydroid.enable = true;
    virtualbox.host = {
      enable = false;
      # enableExtensionPack = true;
    };
    libvirtd = {
      enable = true;
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.inex = {
    isNormalUser = true;
    home = "/home/inex";
    description = "Inex Code";
    extraGroups = [ "wheel" "networkmanager" "jackaudio" "audio" "video" "render" "adbusers" "docker" "cdrom" "scanner" "lp" "libvirtd" "dialout" ];
    openssh.authorizedKeys.keys = [ ];
  };


  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
  system.autoUpgrade.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.variables =
    {
      # AMD_VULKAN_ICD = "RADV";
      DXVK_HDR = "1";
      ENABLE_GAMESCOPE_WSI = "1";
    };

  environment.shellInit = ''
    export VST_PATH=/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst
    export LXVST_PATH=/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst
    export LADSPA_PATH=/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa
    export LV2_PATH=/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2
    export DSSI_PATH=/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi
    export VST3_PATH=/nix/var/nix/profiles/default/lib/vst3:/var/run/current-system/sw/lib/vst3:~/.vst3
  '';

}
