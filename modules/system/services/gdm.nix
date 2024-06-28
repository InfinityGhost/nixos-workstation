{ lib, config, pkgs, ... }:

let
  inherit (lib) mkOption mkIf types;

  cfg = config.services.xserver.displayManager.gdm.monitors.xml;

  xml = pkgs.writeText "monitors.xml" cfg;
in
{
  options.services.xserver.displayManager.gdm.monitors.xml = mkOption {
    description = "monitors.xml content";
    type = types.str;
    default = "";
  };

  config = mkIf (cfg != "") {
    services.displayManager.preStart = ''
      mkdir -p ~gdm/.config
      ln -sf ${xml} ~gdm/.config/monitors.xml
    '';

    home-manager.sharedModules = [{
      home.file.".config/monitors.xml".source = xml;
    }];
  };
}
