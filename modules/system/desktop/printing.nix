{ lib, config, ... }:

let
  inherit (lib) types mkOption mkIf;

  cfg = config.desktop.printing;

in
{
  options.desktop.printing = {
    drivers = mkOption {
      type = with types; listOf package;
      default = [];
    };
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
