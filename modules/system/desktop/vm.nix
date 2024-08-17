{ lib, config, pkgs, ... }:

let
  cfg = config.desktop.vm;

  desktopItem = name: attrs: pkgs.makeDesktopItem ({
    inherit name;
    desktopName = name;
    comment = "Virtual machine for '${name}'";
    type = "Application";
    exec = "${pkgs.libvirt}/bin/virsh --connect qemu:///system start ${name}";
  } // attrs);

  mkEtc = lib.mapAttrs' (name: attrs: {
    name = "X11/sessions/${name}.desktop";
    value.text = (desktopItem name attrs).text;
  });

  mkShares = lib.mapAttrs (name: value: {
    path = value;
    browseable = "yes";
    "acl allow execute always" = "true";
    "read only" = "no";
    "guest ok" = "yes";
    "create mask" = "0644";
    "directory mask" = "0755";
    "force user" = "infinity";
    "force group" = "users";
  });
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
    environment.etc = mkEtc cfg.machines;

    services.samba = lib.mkIf (cfg.shares != {}) {
      enable = true;
      securityType = "user";
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smb_host
        netbios name = smb_host
        security = user
        hosts allow = 192.168.122.0/24 192.168.0.0/23 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
        server min protocol = NT1
        client min protocol = NT1
      '';
      shares = mkShares cfg.shares;
    };
  };
}
