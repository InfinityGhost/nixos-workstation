{ config, lib, pkgs, ... }:

let
  cfg = config.services.vpn;

  server = name: { config = "config /var/lib/openvpn/${name}/${name}.ovpn"; autoStart = false; };
  mapServers = servers: lib.mapAttrs (n: v: (server n) // v) servers;
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
    services.openvpn.servers = mapServers cfg.servers;
  };
}
