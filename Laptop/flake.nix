{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    inex-vscode.url = "git+https://inex.dev/inex-flakes/vscode";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs = { self, nixpkgs, nixos-hardware, ... }@attrs: {
    nixosConfigurations.inex-framework = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules =
        [
          ./configuration.nix
          nixos-hardware.nixosModules.framework-11th-gen-intel
        ];
    };
  };
}
