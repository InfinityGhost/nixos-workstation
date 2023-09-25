{ lib, ... } @ inputs:

let
  inherit (builtins) readDir;
  inherit (lib) nameValuePair filterAttrs mapAttrs' genAttrs foldr;
in rec {
  filesystem = import ./filesystem.nix inputs;
  modules = import ./modules.nix inputs;

  # Supported system types
  systems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];

  # Helper function to generate an attrset
  #   '{ x86_64-linux = f "x86_64-linux"; ... }'
  forAllSystems = f: genAttrs systems (system: f system);

  # Helper function to generate an attrset for all system types for every host
  #   '{ ${name}-${system} = f name system; ... }'
  mapHosts = dir: f: foldr (a: b: a // b) {}
    (map (system:
      mapAttrs'
        (name: _: nameValuePair "${name}-${system}" (f name system))
        (filterAttrs (_: t: t == "directory") (readDir dir)))
      systems
    );
}
