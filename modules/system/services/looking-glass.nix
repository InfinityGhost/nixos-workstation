{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;

  cfg = config.services.looking-glass;

  defaultConfig = {
    app.cursorPollInterval = 2000;
    win = {
      noScreensaver = true;
      quickSplash = true;
      showFps = true;
      uiFont = "Ubuntu";
    };
    input = {
      mouseSmoothing = false;
      rawMouse = true;
    };
    audio = {
      micDefault = "allow";
      micShowIndicator = false;
    };
  };

in {
  options.services.looking-glass = {
    enable = mkEnableOption "Looking Glass Client";

    group = mkOption {
      description = "The group required to use Looking Glass";
      type = types.str;
      default = "libvirtd";
    };

    shmFile = mkOption {
      description = "The path to the shared memory file for looking glass";
      type = types.path;
      default = "/dev/shm/looking-glass";
    };

    config = mkOption {
      description = "The configuration for looking glass";
      type = (pkgs.formats.ini {}).type;
      default = defaultConfig;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      looking-glass-client
    ];

    systemd.tmpfiles.rules = [
      "f ${cfg.shmFile} 0660 nobody ${cfg.group} -"
    ];

    environment.etc."looking-glass-client.ini".text = lib.generators.toINI {} cfg.config;
  };
}
