{ lib, config, pkgs, ... }:

let
  cfg = config.servers.plex;
in
{
  options.servers.plex = with lib; {
    enable = mkEnableOption "Plex Media Server";
  };

  config = lib.mkIf cfg.enable {
    services.plex = {
      enable = true;
      openFirewall = true;
    };
  };
}
