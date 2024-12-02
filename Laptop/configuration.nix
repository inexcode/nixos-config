
{ config, pkgs, lib, fetchpatch, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./software.nix
      ./gnome.nix
      ./zsh.nix
      ./gns3.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];
    kernelModules = [
      "v4l2loopback"
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclisive_caps=1 card_label="Virtual Camera"
    '';

    supportedFilesystems = [ "btrfs" "ntfs" ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "inex" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
    chromium = {
     enableWideVine = true;
    };
    permittedInsecurePackages = [
     #"electron-25.9.0"
     "electron-30.5.1"
     "olm-3.2.16"
    ];
  };

  networking = {
    hostName = "inex-framework";
    networkmanager.enable = true;
    useDHCP = false;
    firewall = {
      enable = false;
      allowedTCPPorts = [ 8437 1716 51820 24642 27036 27037 24800 26000 3979 21000 21013 ];
      allowedUDPPorts = [ 8437 1716 51820 24642 27031 27036 24800 26000 3979 60001 ];
      checkReversePath = true;
    };
    nameservers = [ "10.100.0.101" ];

    hosts = {
      "10.100.100.3" = [ "sonarqube.selfprivacy" ];
      "10.100.100.1" = [ "grafana.lan" "prometheus.lan" "blackbox.lan" ];
      "192.168.1.10" = [ "homelab.inex.cloud" ];
      "10.100.0.100" = [ "autumn-blaze.inex.cloud" ];
      #"192.168.1.3" = [ "fw.ponychord.rocks" ];
    };
    interfaces = {
      # enp0s13f0u1c2 = {
      #   useDHCP = true;
      # };
      # wlp0s20f3 = {
      #   useDHCP = true;
      # };
    };
    wireguard.interfaces = {
      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = [ "10.100.0.2/24" ];
        listenPort = 51839;

        #postSetup = "${pkgs.iproute}/bin/ip route add REDACTED_SERVER_IP via 192.168.1.1";
        #postShutdown = "${pkgs.iproute}/bin/ip route del REDACTED_SERVER_IP via 192.168.1.1";

        # Path to the private key file.
        #
        # Note: The private key can also be included inline via the privateKey option,
        # but this makes the private key world-readable; thus, using privateKeyFile is
        # recommended.
        privateKeyFile = "/etc/nixos/wireguard-keys/private";

        # mtu = 1200;

      preSetup = ''
        ${pkgs.udp2raw}/bin/udp2raw -c -l 127.0.0.1:51820 -r REDACTED_SERVER_IP:9853 -k "REDACTED_KEY" --raw-mode faketcp -a --log-level 0 &
      '';

      postShutdown = ''
        ${pkgs.procps}/bin/pkill -f "udp2raw.*:51820"
      '';


        peers = [
          # For a client configuration, one peer entry for the server will suffice.
          {
            # Public key of the server (not a file path).
            publicKey = "8sEAHYhydEGKTVecXcOb28zeGHGLGCsri5evbSQV8mY=";

            # Forward all the traffic via VPN.
            #allowedIPs = [ "0.0.0.0/0" ];
            # Or forward only particular subnets
            allowedIPs = [ "10.100.0.0/24" "::/0" ];

            # Set this to the server IP and port.
            # endpoint = "REDACTED_SERVER_IP:51820";
            endpoint = "127.0.0.1:51820";

            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    # keyMap = "de";
    useXkbConfig = true;
  };

  # time.timeZone = "Asia/Tbilisi";
  time.timeZone = "Europe/Moscow";

  services = {
    yubikey-agent.enable = true;
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper pkgs.gutenprint pkgs.gutenprintBin ];
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
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    usbmuxd.enable = true;
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
      };
    };
    flatpak.enable = true;
    udev.packages = [
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

  powerManagement.powerDownCommands = ''
    ${pkgs.fw-ectool}/bin/ectool led left blue
  '';
  powerManagement.resumeCommands = ''
    ${pkgs.fw-ectool}/bin/ectool led left auto
  '';

  hardware.pulseaudio.enable = false;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = [ pkgs.libva pkgs.vaapiVdpau pkgs.libvdpau-va-gl pkgs.intel-compute-runtime pkgs.intel-media-driver  ];
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
  };

  programs = {
    adb.enable = true;
    steam = {
      enable = true;
    };
    java = {
      enable = true;
    };
    gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };
    direnv = {
      enable = true;
    };
    thunderbird.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    virtualbox.host = {
      enable = true;
      # enableExtensionPack = true;
    };
    libvirtd = {
      enable = true;
    };
    waydroid.enable = true;
  };

  users.users.inex = {
    isNormalUser = true;
    home = "/home/inex";
    description = "Inex Code";
    extraGroups = [ "wheel" "networkmanager" "jackaudio" "audio" "video" "render" "adbusers" "docker" "cdrom" "scanner" "lp" "libvirtd" "dialout" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQmWNN9YccQecQUOB0n4jYH76gEgSAs4d66eFUZoobt inex@inex-pc"
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment?

}
