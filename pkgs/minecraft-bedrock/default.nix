{ appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "minecraft-bedrock";
  name = pname;
  version = "v1.0.0-798";

  src = fetchurl {
    url = "https://github.com/minecraft-linux/appimage-builder/releases/download/v1.0.0-798/Minecraft_Bedrock_Launcher-x86_64-v1.0.0.798.AppImage";
    hash = "sha256-xPKt6Xn0pR3IWT2ONqZ6+JPe9q0T5bZvXFQpt0hgzAo=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = "minecraft-launcher";
    comment = "Minecraft Bedrock Launcher";
    desktopName = "Minecraft Bedrock";
    categories = [ "Game" ];
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications
  '';
}
