{ appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "minecraft-bedrock";
  name = pname;
  version = "0.10.0";
  buildNumber = "716";

  src = fetchurl {
    url = "https://github.com/ChristopherHX/linux-packaging-scripts/releases/download/v${version}-${buildNumber}/Minecraft_Bedrock_Launcher-x86_64-v${version}.${buildNumber}.AppImage";
    sha256 = "sha256-kHJJau1WMATbqz5L1QSURbG7OC+cHV4tKvdolNzltA4=";
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
