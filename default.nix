{ lib, inputs, pkgs, config, ... }:

with lib;
with lib.my;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ]
    ++ (mapModulesRec' (toString ./modules ) import)
    ++ (mapModules' (toString ./users) import);

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
      nix-gaming.flake = inputs.nix-gaming;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      nixosConfig = config;
    };
  };

  time.timeZone = "America/New_York";

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users.mutableUsers = false;

  services.openssh.enable = true;

  system.stateVersion = "22.05";
}
