{ lib, config, ... }:

with lib;

let
  containers = config.services.containers;

  container = types.submodule {
    options = {
      enable = mkEnableOption "container";
      name = mkOption {
        description = "The name of the container";
        type = with types; nullOr str;
        default = null;
      };
    };
  };

  mkContainer = name: attrs: removeAttrs ({
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
  } // attrs) [ "name" ];

in
{
  options.services.containers = mkOption {
    description = "A set of systemd-nspawn containers";
    type = with types; attrsOf container;
    default = {};
  };

  config = mkIf (containers != {}) {
    users.users.deluge.extraGroups = [ "media" ];

    systemd.nspawn = mapAttrs mkContainer (filterAttrs (n: v: v.enable) containers);
  };
}
