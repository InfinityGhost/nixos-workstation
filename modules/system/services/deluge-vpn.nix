{ config, lib, pkgs, ... }:

let
  cfg = config.services.deluge-vpn;
in
{
  options.services.deluge-vpn = {
    enable = lib.mkEnableOption "Deluge";
    vpns = lib.mkOption {
      type = with lib.types; listOf str;
      description = "The required VPNs for the unit to start";
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    services.deluge.enable = true;

    systemd.services.deluged.requires = map (n: "openvpn-${n}.service") cfg.vpns;

    environment.systemPackages = with pkgs; [
      deluge
    ];
  };
}
