{ lib, config, flake, system, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;

  cfg = config.services.minecraft-bedrock-server;
in
{
  options.services.minecraft-bedrock-server = {
    enable = mkEnableOption "Minecraft Bedrock Server";

    package = mkOption {
      type = types.package;
      default = flake.packages.${system}.minecraft-bedrock-server;
      description = "Package containing the minecraft bedrock server";
    };

    dataDir = mkOption {
      type = types.str;
      description = "Path for server's mutable data";
      default = "/var/lib/minecraft-bedrock";
    };
  };

  config = mkIf (cfg.enable) {
    users.users.minecraft-bedrock = {
      description = "Minecraft Bedrock service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "minecraft-bedrock";
    };
    users.groups.minecraft-bedrock = {};

    systemd.sockets.minecraft-bedrock-server = {
      bindsTo = [ "minecraft-bedrock-server.service" ];
      socketConfig = {
        ListenFIFO = "/run/minecraft-bedrock-server.in";
        SocketMode = "0660";
        SocketUser = "minecraft-bedrock";
        SocketGroup = "minecraft-bedrock";
        RemoveOnStop = true;
        FlushPending = true;
      };
    };

    systemd.services.minecraft-bedrock-server = {
      description = "Minecraft Bedrock server service";
      requires = [ "minecraft-bedrock-server.socket" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/minecraft-bedrock-server";
        User = "minecraft-bedrock";
        WorkingDirectory = cfg.dataDir;

        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
