{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixos";
    };
    opentabletdriver.url = "github:OpenTabletDriver/OpenTabletDriver";
  };

  outputs = inputs @ { self, nixos, nixos-unstable, home-manager, ... }: let
    inherit (builtins) baseNameOf attrValues;
    inherit (lib) nixosSystem genAttrs;
    inherit (lib.my) mapHosts forAllSystems;
    inherit (lib.my.modules) mapModules mapModules' mapModulesRec mapModulesRec';

    lib = nixos.lib.extend (self: super: {
      my = import ./lib (inputs // { inherit lib; });
    });

    # Helper function to configure nixpkgs for a given system
    configureNixpkgs = nixpkgs: system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = (attrValues self.overlays) ++ [ self.overlay ];
    };

  in rec {
    # nixpkgs instantiated for all supported systems
    nixpkgsFor = forAllSystems (system: configureNixpkgs nixos system);

    overlay = final: prev: {
      user = self.packages.${final.system} // { inherit lib; };
      unstable = configureNixpkgs nixos-unstable final.system;
      nix-gaming = inputs.nix-gaming.packages.${final.system};
    };

    overlays = mapModules ./overlays import;

    packages = forAllSystems (system: mapModules ./pkgs (p: nixpkgsFor.${system}.callPackage p {}));

    nixosModules = mapModulesRec ./modules/system import;

    nixosConfigurations = mapHosts ./hosts
      (name: system: nixosSystem {
        specialArgs = { inherit lib inputs system; flake = self; };
        modules = [
          ./hosts/default.nix # shared system config
          ./hosts/${name} # host specific config

          home-manager.nixosModule

          {
            networking.hostName = name; # set hostname
            nixpkgs = {
              hostPlatform = system;
              pkgs = nixpkgsFor.${system};
            };

            imports = (mapModulesRec' ./modules/system import) # system modules
              ++ (mapModules' ./users import); # user configurations
          }
        ];
      });

    devShell = forAllSystems (system: import ./shell.nix { inherit system; flake = self; });
  };
}
