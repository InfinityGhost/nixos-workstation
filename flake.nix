{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fufexan.url = "github:InfinityGhost/nix-gaming/update/osu-stable";
  };

  outputs = { self, nixpkgs, ... } @ inputs: with nixpkgs.lib; let
    mkSystem = { hostName, system ? "x86_64-linux", modules ? [], ... }: nixosSystem {
      inherit system;
      modules = [
        ./common
        ./modules
        (./. + "/hosts/${hostName}")
        ({ networking.hostName = hostName; })
      ] ++ modules;
      specialArgs = {
        inherit inputs hostName;
      };
    };

    # Builds multiple NixOS configurations from a set, using the pair name as the system hostname.
    nixosSystems = systems: mapAttrs (name: value: mkSystem ({ hostName = name; } // value)) systems;

  in {
    nixosConfigurations = nixosSystems {
      nixos-workstation = { modules = [ ./gnome ./development ]; };
      nixos-laptop = { modules = [ ./sway ]; system = "i686-linux"; };
      nixos-iso = {};
      nixos-iso-x86 = { hostName = "nixos-iso"; system = "i686-linux"; };
    };
  };
}
