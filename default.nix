{ lib, inputs, pkgs, ... }:

with lib;
with lib.my;
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ] ++ (mapModulesRec' (toString ./modules ) import);

  nix = {
    distributedBuilds = true;
    settings.trusted-users = [
      "infinity"
      "@root"
    ];

    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command
      experimental-features = nix-command flakes
    '';

    nixPath = [
      "nixpkgs=${inputs.nixos}"
      "nixpkgs-overlays=${dotFilesDir}/overlays"
      "home-manager=${inputs.home-manager}"
      "dotfiles=${dotFilesDir}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    registry = {
      nixos.flake = inputs.nixos;
      nixpkgs.flake = inputs.nixos;
    };
  };
}
