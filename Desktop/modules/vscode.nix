{ config, pkgs, inex-vscode, ... }:

{
  config = {
    environment.systemPackages = [
      inex-vscode.packages.x86_64-linux.default
    ];
  };
}
