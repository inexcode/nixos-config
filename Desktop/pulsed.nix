{ config, pkgs, ... }:

{
  imports =
    [
      ./common.nix
    ];

  services.pipewire = {
    pulse.enable = false;
  };

  hardware.pulseaudio.enable = true;

}
