{ lib, config, ... }:

let
  inherit (lib) types mkOption mkIf;

  cfg = config.desktop.printing;

  mkOpt = type: default: mkOption { inherit type default; };

in
{
  options.desktop.printing = {
    drivers = with types; mkOpt (listOf package) [];
  };

  config = mkIf (cfg.drivers != []) {
    services.printing = {
      enable = true;
      browsing = true;
      drivers = cfg.drivers;
    };

    hardware.sane = {
      enable = true;
      extraBackends = cfg.drivers;
    };
  };
}
