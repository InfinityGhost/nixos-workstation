{ lib, config, pkgs, ... }:

let
  inherit (lib) mkOption mkIf types;

  cfg = config.services.xserver.displayManager.gdm;

  xml = pkgs.writeText "monitors.xml" cfg.monitors.xml;
in
{
  options.services.xserver.displayManager.gdm = {
    monitors.xml = mkOption {
      description = "monitors.xml content";
      type = types.str;
      default = "";
    };
  };

  config = mkIf (cfg.monitors.xml != "") {
    services.xserver.displayManager.job.preStart = ''
      mkdir -p ~gdm/.config
      ln -sf ${xml} ~gdm/.config/monitors.xml
    '';
  };
}
