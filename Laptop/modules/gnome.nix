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
      gnome.enable = true;
    };
  };


  qt5.platformTheme = "gnome";

  environment.systemPackages = with pkgs; [
    gnome.pomodoro
    gnome.gnome-tweaks
    evolution
    gnomeExtensions.gsconnect
    paper-icon-theme
  ];
}
