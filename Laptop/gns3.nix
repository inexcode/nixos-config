{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gns3-gui
    gns3-server
    inetutils
    dynamips
    ubridge
    vpcs
  ];

  security.wrappers.ubridge = {
    source = "/run/current-system/sw/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "users";
    permissions = "u+rx,g+x";
  };
}
