{ pkgs, lib, ... }:

let
  allocatedMemory = "3072M";
in
{
  nixpkgs.overlays = [
    (self: super: rec {
      papermc = super.papermc.overrideAttrs (old: {
        buildPhase = ''
          cat > minecraft-server << EOF
          #!${super.bash}/bin/sh
          exec ${super.adoptopenjdk-jre-hotspot-bin-16}/bin/java \$@ -jar $out/share/papermc/papermc.jar nogui
        '';
      });
    })
  ];

  services.minecraft-server-plugins = {
    enable = true;
    eula = true;
    package = pkgs.papermc;
    jvmOpts = lib.concatStringsSep " " [
      "-Xmx${allocatedMemory}"
      "-Xms${allocatedMemory}"
      "-XX:+UseG1GC"
      "-XX:ParallelGCThreads=2"
      "-XX:MinHeapFreeRatio=5"
      "-XX:MaxHeapFreeRatio=10"
    ];
    serverProperties = {
      motd = "NixOS Minecraft Server";
      server-port = 25565;
      difficulty = 2;
      gamemode = 0;
      max-players = 5;
      white-list = false;
      enable-rcon = false;
      allow-flight = true;
    };
    operators = {
      InfinityGhost = "b780259d-7f37-4043-a571-564ea04ce34e";
    };
    plugins = [
      (builtins.fetchurl {
        name = "Geyser-Spigot";
        url = "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/912/artifact/bootstrap/spigot/target/Geyser-Spigot.jar";
        sha256 = "161cbx5c9kaq9az4s162w5g0kmw98n2z69r7wfip19hrslzxn3ja";
      })
      (builtins.fetchurl {
        name = "Floodgate";
        url = "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/40/artifact/spigot/target/floodgate-spigot.jar";
        sha256 = "1n323nz1hphsyzp7479nf8b72l0sa6zl40av97wk86kwvhyb990n";
      })
      (builtins.fetchurl {
        name = "EssentialsX";
        url = "https://github.com/EssentialsX/Essentials/releases/download/2.19.0/EssentialsX-2.19.0.jar";
        sha256 = "03jn9grinjlh2kc8i1gcvj3bz7mww4z131aj1s7kw9qk7p20nn1r";
      })
    ];
  };
}
