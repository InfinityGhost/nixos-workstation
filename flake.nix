{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fufexan.url = "github:fufexan/nix-gaming";
  };

  outputs = inputs: let
    overlays = {
      nixpkgs.overlays = inputs.nixpkgs.lib.lists.flatten [
        (import ./overlays)
        (import ./pkgs)
      ];
    };

  in {
    nixosConfigurations.nixos-workstation = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        overlays
        ./modules
        ./configuration.nix
        inputs.fufexan.nixosModule
      ];
      specialArgs = {
        inherit inputs;
      };
    };
  };
}