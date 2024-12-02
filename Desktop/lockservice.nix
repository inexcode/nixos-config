{ config, pkgs, lib, fetchpatch, ... }:

{
  systemd.services."lock-inex" = {
    description = "Lock Inex' session";
    environment = config.nix.envVars // {
      DISPLAY = ":0";
      WAYLAND_DISPLAY = "wayland-0";
    };
    restartIfChanged = false;
    serviceConfig = {
      User = "inex";
      Type = "simple";
      ExecStart = "${pkgs.xdg-utils}/bin/xdg-screensaver lock";
    };
  };
}
