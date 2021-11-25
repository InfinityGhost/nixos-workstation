{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.minecraft-server-plugins;

  # We don't allow eula=false anyways
  eulaFile = builtins.toFile "eula.txt" ''
    # eula.txt managed by NixOS Configuration
    eula=true
  '';

  minecraftUUID = types.strMatching "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" // {
    description = "Minecraft UUID";
  };

  buildPlayerListFile = file: list: pkgs.writeText file
    (builtins.toJSON
      (mapAttrsToList (n: v: { name = n; uuid = v; }) list));

  whitelistFile = buildPlayerListFile "whitelist.json" cfg.whitelist;
  operatorsFile = buildPlayerListFile "ops.json" cfg.operators;

  cfgToString = v: if builtins.isBool v then boolToString v else toString v;

  serverPropertiesFile = pkgs.writeText "server.properties" (''
    # server.properties managed by NixOS configuration
  '' + concatStringsSep "\n" (mapAttrsToList
    (n: v: "${n}=${cfgToString v}") cfg.serverProperties));


  # To be able to open the firewall, we need to read out port values in the
  # server properties, but fall back to the defaults when those don't exist.
  # These defaults are from https://minecraft.gamepedia.com/Server.properties#Java_Edition_3
  defaultServerPort = 25565;

  serverPort = cfg.serverProperties.server-port or defaultServerPort;

  rconPort = if cfg.serverProperties.enable-rcon or false
    then cfg.serverProperties."rcon.port" or 25575
    else null;

  queryPort = if cfg.serverProperties.enable-query or false
    then cfg.serverProperties."query.port" or 25565
    else null;

  pluginPaths = map (jar: "\"${jar}\"") cfg.plugins;

in {
  options = {
    services.minecraft-server-plugins = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, start a Minecraft Server. The server
          data will be loaded from and saved to
          <option>services.minecraft-server-plugins.dataDir</option>.
        '';
      };

      autoStart = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, the server will be started as soon as the network is available.
          It will need to be started manually otherwise.
        '';
      };

      eula = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether you agree to
          <link xlink:href="https://account.mojang.com/documents/minecraft_eula">
          Mojangs EULA</link>. This option must be set to
          <literal>true</literal> to run Minecraft server.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/minecraft";
        description = ''
          Directory to store Minecraft database and other state/data files.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
        '';
      };

      whitelist = mkOption {
        type = types.attrsOf minecraftUUID;
        default = {};
        description = ''
          Whitelisted players, only has an effect when the whitelist is enabled
          via <option>services.minecraft-server-plugins.serverProperties</option> by
          setting <literal>white-list</literal> to <literal>true</literal>.
          This is a mapping from Minecraft usernames to UUIDs.
          You can use <link xlink:href="https://mcuuid.net/"/> to get a
          Minecraft UUID for a username.
        '';
        example = literalExpression ''
          {
            username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
            username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
          };
        '';
      };

      operators = mkOption {
        type = types.attrsOf minecraftUUID;
        default = {};
        description = ''
          Operators on the minecraft server.
          This is a mapping from Minecraft usernames to UUIDs.
          You can use <link xlink:href="https://mcuuid.net/"/> to get a
          Minecraft UUID for a username.
        '';
        example = literalExpression ''
          {
            username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
            username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
          };
        '';
      };

      serverProperties = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        default = {};
        example = literalExpression ''
          {
            server-port = 43000;
            difficulty = 3;
            gamemode = 1;
            max-players = 5;
            motd = "NixOS Minecraft server!";
            white-list = true;
            enable-rcon = true;
            "rcon.password" = "hunter2";
          }
        '';
        description = ''
          Minecraft server properties for the server.properties file. Only has
          an effect when <option>services.minecraft-server-plugins.declarative</option>
          is set to <literal>true</literal>. See
          <link xlink:href="https://minecraft.gamepedia.com/Server.properties#Java_Edition_3"/>
          for documentation on these values.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.minecraft-server;
        defaultText = literalExpression "pkgs.minecraft-server";
        example = literalExpression "pkgs.minecraft-server_1_12_2";
        description = "Version of minecraft-server to run.";
      };

      jvmOpts = mkOption {
        type = types.separatedString " ";
        default = "-Xmx2048M -Xms2048M";
        # Example options from https://minecraft.gamepedia.com/Tutorials/Server_startup_script
        example = "-Xmx2048M -Xms4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing "
          + "-XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 "
          + "-XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
        description = "JVM options for the Minecraft server.";
      };

      plugins = mkOption {
        type = with types; listOf package;
        default = [];
        description = "Plugins to be installed on the server.";
      };
    };
  };

  config = mkIf cfg.enable {

    users.users.minecraft = {
      description     = "Minecraft server service user";
      home            = cfg.dataDir;
      createHome      = true;
      isSystemUser    = true;
      group           = "minecraft";
    };
    users.groups.minecraft = {};

    systemd.services.minecraft-server = {
      description   = "Minecraft Server Service";
      wantedBy      = optional cfg.autoStart "multi-user.target";
      after         = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/minecraft-server ${cfg.jvmOpts}";
        Restart = "always";
        User = "minecraft";
        WorkingDirectory = cfg.dataDir;
      };

      preStart = ''
        ln -sf ${eulaFile} eula.txt

        if [ -e .declarative ]; then

          # Was declarative before, no need to back up anything
          ln -sf ${whitelistFile} whitelist.json
          ln -sf ${operatorsFile} ops.json
          cp -f ${serverPropertiesFile} server.properties

        else

          # Declarative for the first time, backup stateful files
          ln -sb --suffix=.stateful ${whitelistFile} whitelist.json
          cp -b --suffix=.stateful ${serverPropertiesFile} server.properties

          # server.properties must have write permissions, because every time
          # the server starts it first parses the file and then regenerates it..
          chmod +w server.properties
          echo "Autogenerated file that signifies that this server configuration is managed declaratively by NixOS" \
            > .declarative

        fi

        # Link all plugins
        mkdir -p ${cfg.dataDir}/plugins
        '' + "plugins=(" + (concatStringsSep " " pluginPaths) + ")" + "\n" + ''
        for jar in ''${plugins[@]}; do
          basename=`basename $jar`
          name=''${basename:33}.jar
          path="${cfg.dataDir}/plugins/$name"
          [ -f "$path" ] && rm $path
          ln -s $jar $path
        done
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ serverPort ];
      allowedTCPPorts = [ serverPort ]
        ++ optional (queryPort != null) queryPort
        ++ optional (rconPort != null) rconPort;
    };

    assertions = [
      { assertion = cfg.eula;
        message = "You must agree to Mojangs EULA to run minecraft-server."
          + " Read https://account.mojang.com/documents/minecraft_eula and"
          + " set `services.minecraft-server-plugins.eula` to `true` if you agree.";
      }
    ];

  };
}
