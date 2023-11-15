{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkOption mkEnableOption mkIf;

  cfg = config.desktop.vnc-server;
  mkOpt = type: default: mkOption { inherit type default; };

in {
  options.desktop.vnc-server = {
    enable = mkEnableOption "VNC server";
    package = mkOpt types.package pkgs.tigervnc;
    binPath = mkOpt types.path "${cfg.package}/bin/x0vncserver";
    arguments = mkOpt types.str "-PasswordFile ~/.vnc/passwd";
  };

  config = mkIf cfg.enable {
    systemd.user.services.vnc-server.script = "${cfg.binPath} ${cfg.arguments}";
    environment.systemPackages = [ cfg.package ];
  };
}
