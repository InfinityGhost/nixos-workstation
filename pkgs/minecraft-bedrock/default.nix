{ appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "minecraft-bedrock";
  name = pname;
  version = "v1.1.1-802";

  src = fetchurl {
    url = "https://github.com/minecraft-linux/appimage-builder/releases/download/v1.1.1-802/Minecraft_Bedrock_Launcher-x86_64-v1.1.1.802.AppImage";
    hash = "sha256-lK7c/1ieFGOtWVU0vGKfyQJiBu8NJAQjR0DvpZUE0Ns=";
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
