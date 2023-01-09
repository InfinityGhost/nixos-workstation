{ config, lib, pkgs, ... }:

let
  cfg = config.services.deluge;

  services = map (n: "openvpn-${n}.service") cfg.vpns;
in
{
  options.services.deluge.vpns = lib.mkOption {
    type = with lib.types; listOf str;
    description = "The required VPNs for the unit to start";
    default = [];
  };

  config = lib.mkIf (cfg.vpns != []) {
    systemd.services.deluged = {
      bindsTo = services;
      requires = services;
      after = services;
    };

    environment.systemPackages = with pkgs; [
      deluge
    ];
  };
}
