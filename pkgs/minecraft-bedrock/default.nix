{ appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "minecraft-bedrock";
  name = pname;
  version="v0.15.2-796";

  src = fetchurl {
    url = "https://github.com/minecraft-linux/appimage-builder/releases/download/v0.15.2-796/Minecraft_Bedrock_Launcher-x86_64-v0.15.2.796.AppImage";
    hash = "sha256-4Vb6y9H6SVrzkVjx1GEka1JxOp1zIzgRrrOMS7GXMgA=";
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
