{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf mapAttrs mapAttrs';

  cfg = config.desktop.vm;

  desktopItem = name: attrs: pkgs.makeDesktopItem ({
    inherit name;
    desktopName = name;
    comment = "Virtual machine for '${name}'";
    type = "Application";
    exec = "${pkgs.libvirt}/bin/virsh --connect qemu:///system start ${name}";
  } // attrs);

in
{
  options.desktop.vm = with lib; {
    machines = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Virtual machines to be listed as desktop environments
      '';
    };
    shares = mkOption {
      type = with types; attrsOf str;
      default = {};
      description = ''
        Samba shares available to the virtual machines
      '';
    };
  };

  config = lib.mkIf (cfg.machines != {}) {
    services.single-gpu-passthrough.machines = builtins.attrNames cfg.machines;
    environment.etc = mapAttrs' (name: attrs: {
      name = "X11/sessions/${name}.desktop";
      value.text = (desktopItem name attrs).text;
    }) cfg.machines;

    services.samba = mkIf (cfg.shares != {}) {
      enable = false; # TODO: fix config, doesn't appear to work.
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server string" = "%h-smb";
          "netbios name" = "%h-smb";
          security = "user";        
        };
      } // (mapAttrs (name: path: {
        inherit path;
        browseable = "yes";
        "acl allow execute always" = "true";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "infinity";
        "force group" = "users";
        "hosts allow" = "192.168.122.0/24 192.168.0.0/23 localhost";
        "hosts deny" = "0.0.0.0/0";
      }) cfg.shares);
    };
  };
}
