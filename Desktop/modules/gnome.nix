{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
      };
    };
    desktopManager = {
      gnome.enable = true;
    };
  };

  services.gnome.gnome-remote-desktop.enable = true;

  qt.platformTheme = "gnome";

  environment.systemPackages = with pkgs; [
    gnome-pomodoro
    gnome-tweaks
    gnome-remote-desktop
    networkmanager-openvpn
    mission-center
    rhythmbox
    evolution
    gnomeExtensions.gsconnect
    paper-icon-theme
  ];
}

