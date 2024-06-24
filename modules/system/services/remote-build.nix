{ config, lib, ... }:

let
  inherit (lib) types mkDefault mkOption mkIf;

  cfg = config.services.remote-build;  
in
{
  options.services.remote-build = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables nix distributed builds.
      '';
    };
  };

  config = mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/issues/282856
    security.pam.sshAgentAuth.enable = true;

    nix.buildMachines = [
      {
        hostName = "nixos-workstation";
        system = "x86_64-linux,i686-linux,aarch64-linux";
        maxJobs = 8;
        speedFactor = 10;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [];
      }
    ];
  };
}
