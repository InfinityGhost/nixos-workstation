{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixos";
    };
  };

  outputs = inputs @ { self, nixos, nixos-unstable, home-manager, ... }: let
    inherit (builtins) baseNameOf;
    inherit (lib) nixosSystem mkIf removeSuffix attrNames attrValues;
    inherit (lib.my) dotFilesDir mapModules mapModulesRec mapHosts;

    system = "x86_64-linux";

    lib = nixos.lib.extend
      (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

    mkPkgs = pkgs: extraOverlays: import pkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = extraOverlays ++ (attrValues self.overlays);
    };
    pkgs = mkPkgs nixos [ self.overlay ];
    pkgsUnstable = mkPkgs nixos-unstable [];

  in {
    inherit lib pkgs;

    overlay = final: prev: {
      user = self.packages.${system} // { inherit lib; };
      unstable = pkgsUnstable;
      nix-gaming = inputs.nix-gaming.packages.${system};
    };

    overlays = mapModules ./overlays import;

    packages."${system}" = mapModules ./pkgs (p: pkgs.callPackage p {});

    nixosModules = { dotfiles = import ./.; } // mapModulesRec ./modules/system import;

    nixosConfigurations = mapHosts ./hosts { inherit system; };

    devShell."${system}" = import ./shell.nix { inherit pkgs; };
  };
}
