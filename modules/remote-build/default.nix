{ config, lib, ... }:

with lib;

let
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

  config.nix = mkIf cfg.enable {
    buildMachines = [
      {
        hostName = "192.168.0.2";
        system = "x86_64-linux,i686-linux";
        maxJobs = 8;
        speedFactor = 10;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [];
      }
    ];
  };
}