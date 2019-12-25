{ config, pkgs, ... }:

{
  imports =
    [
      ./configuration.nix
    ];

  services.jack = {
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jackd = {
      enable = true;
    };
  };

  environment.systemPackages = [ 
    pkgs.ardour
    # pkgs.cadence
    pkgs.qjackctl
  ];

}

