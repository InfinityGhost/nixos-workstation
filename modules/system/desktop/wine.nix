{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkEnableOption mkOption mkIf;

  cfg = config.desktop.wine;
in
{
  options.desktop.wine = {
    enable = mkEnableOption "wine";
    package = mkOption {
      description = ''
        The wine package set to use
        Default is wine staging x86-64
      '';
      type = types.package;
      default = pkgs.wineWowPackages;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
