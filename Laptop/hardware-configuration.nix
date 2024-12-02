{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      luks.yubikeySupport = true;
      luks.devices = {
        "nixos-enc" = {
          device = "/dev/nvme0n1p2";
          preLVM = true;
          yubikey = {
            slot = 2;
            twoFactor = true; # Set to false if you did not set up a user password.
            storage = {
              device = "/dev/nvme0n1p1";
            };
          };
        };
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernel.sysctl = { "vm.swappiness" = 5;};
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b4f478f3-1f32-48ba-a461-f07a91cabc34";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/b4f478f3-1f32-48ba-a461-f07a91cabc34";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/b4f478f3-1f32-48ba-a461-f07a91cabc34";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/b4f478f3-1f32-48ba-a461-f07a91cabc34";
      fsType = "btrfs";
      options = [ "subvol=docker" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6D12-4D2B";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/0ab39d9b-9a74-4f3e-b8ae-5674b2a701dd"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u1c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
