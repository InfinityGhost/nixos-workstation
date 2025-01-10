{ lib, inputs, pkgs, config, flake, ... }:

let
  inherit (builtins) attrValues trace;
  inherit (lib.my.modules) mapModulesRec';
in {
  nix = {
    distributedBuilds = true;
    settings.trusted-users = [
      "infinity"
      "@root"
    ];

    package = pkgs.nixVersions.stable;

    extraOptions = ''
      experimental-features = nix-command
      experimental-features = nix-command flakes
    '';

    nixPath = [
      "nixpkgs=${inputs.nixos}"
      "nixpkgs-overlays=${../overlays}"
      "home-manager=${inputs.home-manager}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    registry = {
      nixos.flake = inputs.nixos;
      nixpkgs.flake = inputs.nixos;
      unstable.flake = inputs.nixos-unstable;
      nix-gaming.flake = inputs.nix-gaming;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [ { home.stateVersion = config.system.stateVersion; } ]
      ++ mapModulesRec' ../modules/home import;
    extraSpecialArgs = {
      inherit inputs;
      nixosPkgs = pkgs;
    };
  };

  time.timeZone = "America/New_York";

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users.mutableUsers = false;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "22.05";
}
