{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.services.printing;

  drivers = with pkgs.unstable; [ hplipWithPlugin ];
in
{
  options.services.printing.enableHP = mkEnableOption "hplip and config";

  config = mkIf cfg.enableHP {
    services.printing = {
      enable = true;
      browsing = true;
      inherit drivers;
    };

    hardware.sane = {
      enable = true;
      extraBackends = drivers;
    };
  };
}
