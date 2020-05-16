{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = false;
      };
    };
    desktopManager = {
      gnome3.enable = true;
    };
  };
  

  qt5.platformTheme = "gnome";

  environment.systemPackages = with pkgs; [
    gnome3.pomodoro
    gnome3.gnome-tweaks
    gnome3.networkmanager-openvpn
    gnome3.evolution
    gnomeExtensions.gsconnect
    paper-icon-theme
  ];
}
