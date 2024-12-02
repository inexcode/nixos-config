{

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "path:/home/inex/dev/nixpkgs";
    inex-vscode.url = "git+https://inex.dev/inex-flakes/vscode";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };


  outputs = { self, nixpkgs, inex-vscode, ... }@attrs: {
    nixosConfigurations.inex-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules =
        [
          ./configuration.nix
          ./pipewire.nix
          #chaotic.nixosModules.default
        ];
    };
  };
}
