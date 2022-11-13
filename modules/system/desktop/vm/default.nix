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

  mkEtc = lib.attrsets.mapAttrs' (name: attrs: {
    name = "X11/sessions/${name}.desktop";
    value.text = (desktopItem name attrs).text;
  });
in
{
  options.desktop.vm = with lib; {
    enable = mkEnableOption "Virtual machine desktop environments";
    machines = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Virtual machines to be listed as desktop environments
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.single-gpu-passthrough.machines = builtins.attrNames cfg.machines;
    environment.etc = mkEtc cfg.machines;
  };
}
