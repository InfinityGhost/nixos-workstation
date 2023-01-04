{ config, lib, pkgs, ... }:

let
  cfg = config.services.vpn;

  server = name: { config = "config /var/lib/openvpn/${name}/${name}.ovpn"; autoStart = false; };
in
{
  options.services.vpn = {
    servers = lib.mkOption {
      description = "OpenVPN servers";
      type = lib.types.attrs;
      default = {};
    };
  };

  config = with lib; mkIf (cfg.servers != {}) {
    services.openvpn.servers = lib.mapAttrs (n: v: (server n) // v) cfg.servers;
  };
}
