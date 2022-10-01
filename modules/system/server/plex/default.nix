{ lib, config, pkgs, ... }:

let
  cfg = config.server.plex;
in
{
  options.server.plex = with lib; {
    enable = mkEnableOption "Plex Media Server";
  };

  config = lib.mkIf cfg.enable {
    services.plex = {
      enable = true;
      openFirewall = true;
    };
  };
}
