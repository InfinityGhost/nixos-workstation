{ lib, config, ... }:

with lib;

let
  cfg = config.services.containers;

  mkContainer = name: {
    enable = true;
    execConfig = {
      Timezone = "Bind";
      Hostname = "${name}-container";
    };
    filesConfig = {
      Bind = [ "/repos" ];
      Volatile = false;
    };
    networkConfig = {
      Private = true;
      VirtualEthernet = true;
      Bridge = "virbr0";
    };
  };

in
{
  options.services.containers = {
    containers = mkOption {
      description = "A set of containers";
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf (cfg.containers != {}) {
    systemd.nspawn = lib.mapAttrs (n: v: mkContainer v) cfg.containers;
  };
}
