{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = true;
      };
    };
    desktopManager = {
      gnome.enable = true;
    };
  };

  qt.platformTheme = "gnome";

  environment.systemPackages = with pkgs; [
    gnome-pomodoro
    gnome-tweaks
    gnome.gnome-remote-desktop
    gnome.networkmanager-openvpn
    rhythmbox
    gnomeExtensions.gsconnect
    paper-icon-theme
  ];
}
